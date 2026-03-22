import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../models/driver_route.dart';
import '../models/geocoded_order.dart';
import '../models/route_stop.dart';
import 'route_optimizer_interface.dart';
import 'osrm_service.dart';

/// Fallback VRP Solver (used when Google Route Optimization is not configured).
///
/// Algorithm:
/// 1. Clarke-Wright Savings — merges nearby orders onto the same driver.
/// 2. Force-split largest routes if merged count < driverCount.
/// 3. Nearest-neighbour TSP within each route.
/// 4. OSRM for road geometry.
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

    final k = min(driverCount, orders.length);

    // Step 1: Clarke-Wright savings clustering
    final clusters = _savingsCluster(
      orders: orders,
      driverCount: k,
      kmCapPerDriver: kmCapPerDriver,
      depot: depot,
    );

    // Step 2: TSP + OSRM per cluster
    final routes = <DriverRoute>[];
    for (int i = 0; i < clusters.length; i++) {
      final cluster = clusters[i];
      if (cluster.isEmpty) continue;

      final sorted = _nearestNeighbourTsp(cluster, depot);
      final waypoints = [depot, ...sorted.map((o) => o.location)];

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

      final stops = sorted.asMap().entries.map((e) => RouteStop(
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

    final routeOf = List<int>.generate(n, (i) => i);
    final routes = List<List<int>>.generate(n, (i) => [i]);

    // Compute and sort savings descending
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

    for (final sv in savings) {
      final ri = routeOf[sv.i];
      final rj = routeOf[sv.j];
      if (ri == rj) continue;
      if (routes[ri].isEmpty || routes[rj].isEmpty) continue;

      final merged = _tryMerge(routes[ri], routes[rj], sv.i, sv.j);
      if (merged == null) continue;

      final km = _routeKm(merged, orders, depot);
      if (km > kmCapPerDriver) continue;

      routes[ri] = merged;
      routes[rj] = [];
      for (final idx in merged) routeOf[idx] = ri;
    }

    final active = routes.where((r) => r.isNotEmpty).toList();

    // Too many routes → consolidate
    _consolidate(active, orders, depot, driverCount, kmCapPerDriver);

    // Too few routes → split largest until we reach driverCount
    _splitToReach(active, orders, depot, driverCount);

    return active
        .where((r) => r.isNotEmpty)
        .map((r) => r.map((idx) => orders[idx]).toList())
        .toList();
  }

  List<int>? _tryMerge(List<int> a, List<int> b, int i, int j) {
    if (a.last == i && b.first == j) return [...a, ...b];
    if (b.last == j && a.first == i) return [...b, ...a];
    if (a.last == i && b.last == j) return [...a, ...b.reversed];
    if (a.first == i && b.first == j) return [...a.reversed, ...b];
    return null;
  }

  void _consolidate(
    List<List<int>> active,
    List<GeocodedOrder> orders,
    LatLng depot,
    int driverCount,
    double kmCapPerDriver,
  ) {
    while (active.length > driverCount) {
      active.sort((a, b) =>
          _routeKm(a, orders, depot).compareTo(_routeKm(b, orders, depot)));

      bool merged = false;
      for (int j = 1; j < active.length; j++) {
        final combined = [...active[0], ...active[j]];
        if (_routeKm(combined, orders, depot) <= kmCapPerDriver * 1.2) {
          active[j] = combined;
          active.removeAt(0);
          merged = true;
          break;
        }
      }
      if (!merged) {
        active[1] = [...active[0], ...active[1]];
        active.removeAt(0);
      }
    }
  }

  /// Splits the largest route at its geographic midpoint until we have
  /// exactly [driverCount] routes. This ensures all drivers are used.
  void _splitToReach(
    List<List<int>> active,
    List<GeocodedOrder> orders,
    LatLng depot,
    int driverCount,
  ) {
    while (active.length < driverCount) {
      // Find the route with the most orders
      int largestIdx = 0;
      for (int i = 1; i < active.length; i++) {
        if (active[i].length > active[largestIdx].length) largestIdx = i;
      }

      final route = active[largestIdx];
      if (route.length < 2) break; // can't split a single-stop route

      // Split at the geographic midpoint of the TSP-sorted route
      // Use the pair of adjacent stops with the largest inter-stop distance
      // as the split point — this is the natural "seam" between two areas.
      int splitAt = _bestSplitPoint(route, orders, depot);

      final partA = route.sublist(0, splitAt);
      final partB = route.sublist(splitAt);

      if (partA.isEmpty || partB.isEmpty) break;

      active[largestIdx] = partA;
      active.add(partB);
    }
  }

  /// Returns the index to split at: the point after the longest gap
  /// between consecutive stops (including depot→first and last→depot).
  int _bestSplitPoint(List<int> route, List<GeocodedOrder> orders, LatLng depot) {
    double maxGap = -1;
    int splitAt = route.length ~/ 2; // fallback: split in half

    final points = [
      depot,
      ...route.map((i) => orders[i].location),
      depot,
    ];

    for (int i = 1; i < points.length - 1; i++) {
      final gap = _haversineKm(points[i], points[i + 1]);
      if (gap > maxGap) {
        maxGap = gap;
        splitAt = i; // split after position i (1-indexed in route)
      }
    }

    return splitAt.clamp(1, route.length - 1);
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

  double _routeKm(List<int> indices, List<GeocodedOrder> orders, LatLng depot) {
    if (indices.isEmpty) return 0;
    final points = [depot, ...indices.map((i) => orders[i].location), depot];
    return _totalHaversineKm(points);
  }
}

class _Saving {
  const _Saving(this.i, this.j, this.value);
  final int i;
  final int j;
  final double value;
}
