import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../models/driver_route.dart';
import '../models/geocoded_order.dart';
import '../models/route_stop.dart';
import 'route_optimizer_interface.dart';
import 'osrm_service.dart';

/// VRP Solver using the Clarke-Wright Savings Algorithm:
///
/// 1. Every order starts as its own route: depot → order → depot.
/// 2. Compute savings for every pair (i, j):
///      s(i,j) = d(depot,i) + d(depot,j) − d(i,j)
///    High savings = i and j are close → combining them avoids backtracking.
/// 3. Greedily merge routes in descending savings order, subject to km cap.
/// 4. If merged routes > driverCount, consolidate smallest routes.
/// 5. Nearest-neighbour TSP to sort stops within each route.
/// 6. OSRM for real road geometry.
///
/// This naturally packs nearby deliveries onto one driver without
/// enforcing equal order counts — a driver might get 10 stops in one
/// neighbourhood while another gets 2 on the other side of town.
class VrpSolver implements RouteOptimizerInterface {
  VrpSolver({required this.osrmService});

  final OsrmService osrmService;

  @override
  Future<List<DriverRoute>> optimize({
    required List<GeocodedOrder> orders,
    required int driverCount,
    required double kmCapPerDriver,
    required LatLng depot,
  }) async {
    if (orders.isEmpty) return [];

    // Step 1 & 2: Clarke-Wright savings clustering
    final clusters = _savingsCluster(
      orders: orders,
      driverCount: driverCount,
      kmCapPerDriver: kmCapPerDriver,
      depot: depot,
    );

    // Step 3: nearest-neighbour TSP within each cluster
    final sortedClusters =
        clusters.map((c) => _nearestNeighbourTsp(c, depot)).toList();

    // Step 4: OSRM route geometry per driver
    final routes = <DriverRoute>[];
    for (int i = 0; i < sortedClusters.length; i++) {
      final cluster = sortedClusters[i];
      if (cluster.isEmpty) continue;

      final waypoints = [depot, ...cluster.map((o) => o.location)];
      List<LatLng> polyline;
      double distanceKm;
      try {
        final result = await osrmService.getRoute(waypoints);
        polyline = result.geometry;
        distanceKm = result.distanceKm;
      } catch (_) {
        polyline = waypoints;
        distanceKm = _totalHaversineKm(waypoints);
      }

      final stops = cluster.asMap().entries.map((e) => RouteStop(
            stopNumber: e.key + 1,
            order: e.value.order,
            location: e.value.location,
          )).toList();

      routes.add(DriverRoute(
        driverIndex: i,
        color: AppColors.driverColor(i),
        stops: stops,
        polyline: polyline,
        totalDistanceKm: distanceKm,
      ));
    }

    return routes;
  }

  // ── Clarke-Wright Savings ──────────────────────────────────────────────────

  List<List<GeocodedOrder>> _savingsCluster({
    required List<GeocodedOrder> orders,
    required int driverCount,
    required double kmCapPerDriver,
    required LatLng depot,
  }) {
    final n = orders.length;

    // Each order starts as its own route [i]
    // routeOf[i] = which route index order i currently belongs to
    final routeOf = List<int>.generate(n, (i) => i);
    // routes[r] = ordered list of order indices in route r ([] = merged away)
    final routes = List<List<int>>.generate(n, (i) => [i]);
    // Estimated km for each route (depot → stops → depot, straight-line)
    final routeKm = List<double>.generate(
        n, (i) => _haversineKm(depot, orders[i].location) * 2);

    // Compute all pairwise savings and sort descending
    final savings = <_Saving>[];
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final s = _haversineKm(depot, orders[i].location) +
            _haversineKm(depot, orders[j].location) -
            _haversineKm(orders[i].location, orders[j].location);
        if (s > 0) savings.add(_Saving(i, j, s));
      }
    }
    savings.sort((a, b) => b.value.compareTo(a.value));

    // Greedily merge
    for (final sv in savings) {
      final ri = routeOf[sv.i];
      final rj = routeOf[sv.j];

      if (ri == rj) continue; // already in same route
      if (routes[ri].isEmpty || routes[rj].isEmpty) continue;

      // Valid merge requires sv.i to be an endpoint of ri and
      // sv.j to be an endpoint of rj (so no detour through depot).
      final List<int>? merged = _tryMerge(routes[ri], routes[rj], sv.i, sv.j);
      if (merged == null) continue;

      // Check km cap
      final km = _routeKmFromIndices(merged, orders, depot);
      if (km > kmCapPerDriver) continue;

      // Commit merge into ri, clear rj
      routes[ri] = merged;
      routes[rj] = [];
      routeKm[ri] = km;
      for (final idx in merged) {
        routeOf[idx] = ri;
      }
    }

    // Collect non-empty routes
    final active = routes.where((r) => r.isNotEmpty).toList();

    // If more routes than drivers, consolidate smallest into nearest
    _consolidate(active, orders, depot, driverCount, kmCapPerDriver);

    return active
        .where((r) => r.isNotEmpty)
        .map((r) => r.map((idx) => orders[idx]).toList())
        .toList();
  }

  /// Attempts to join routeA and routeB at their endpoints i (in A) and j (in B).
  /// Returns the merged list, or null if the endpoints don't allow a valid merge.
  List<int>? _tryMerge(List<int> a, List<int> b, int i, int j) {
    final aEnd = a.last == i;
    final aStart = a.first == i;
    final bStart = b.first == j;
    final bEnd = b.last == j;

    if (aEnd && bStart) return [...a, ...b];
    if (bEnd && aStart) return [...b, ...a];
    if (aEnd && bEnd) return [...a, ...b.reversed];
    if (aStart && bStart) return [...a.reversed, ...b];
    return null;
  }

  /// When we have more routes than drivers, merge the two routes whose
  /// combined km is smallest (least detour), until we hit driverCount.
  void _consolidate(
    List<List<int>> active,
    List<GeocodedOrder> orders,
    LatLng depot,
    int driverCount,
    double kmCapPerDriver,
  ) {
    while (active.length > driverCount) {
      // Sort by route km ascending so we merge smallest first
      active.sort((a, b) =>
          _routeKmFromIndices(a, orders, depot)
              .compareTo(_routeKmFromIndices(b, orders, depot)));

      bool merged = false;
      for (int j = 1; j < active.length; j++) {
        final combined = [...active[0], ...active[j]];
        final km = _routeKmFromIndices(combined, orders, depot);
        // Allow up to 20% over cap during consolidation to avoid deadlock
        if (km <= kmCapPerDriver * 1.2) {
          active[j] = combined;
          active.removeAt(0);
          merged = true;
          break;
        }
      }

      // If nothing fits, just merge the two smallest unconditionally
      if (!merged) {
        active[1] = [...active[0], ...active[1]];
        active.removeAt(0);
      }
    }
  }

  // ── Nearest-neighbour TSP ─────────────────────────────────────────────────

  List<GeocodedOrder> _nearestNeighbourTsp(
      List<GeocodedOrder> orders, LatLng depot) {
    if (orders.length <= 1) return orders;

    final remaining = List<GeocodedOrder>.from(orders);
    final route = <GeocodedOrder>[];
    LatLng current = depot;

    while (remaining.isNotEmpty) {
      int nearestIdx = 0;
      double nearestDist = _haversineKm(current, remaining[0].location);
      for (int i = 1; i < remaining.length; i++) {
        final d = _haversineKm(current, remaining[i].location);
        if (d < nearestDist) {
          nearestDist = d;
          nearestIdx = i;
        }
      }
      current = remaining[nearestIdx].location;
      route.add(remaining.removeAt(nearestIdx));
    }

    return route;
  }

  // ── Distance helpers ──────────────────────────────────────────────────────

  double _haversineKm(LatLng a, LatLng b) {
    const r = 6371.0;
    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;
    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    return 2 * r * asin(sqrt(h));
  }

  double _totalHaversineKm(List<LatLng> points) {
    double total = 0;
    for (int i = 0; i < points.length - 1; i++) {
      total += _haversineKm(points[i], points[i + 1]);
    }
    return total;
  }

  double _routeKmFromIndices(
      List<int> indices, List<GeocodedOrder> orders, LatLng depot) {
    if (indices.isEmpty) return 0;
    final points = [
      depot,
      ...indices.map((i) => orders[i].location),
      depot,
    ];
    return _totalHaversineKm(points);
  }
}

class _Saving {
  const _Saving(this.i, this.j, this.value);
  final int i;
  final int j;
  final double value;
}
