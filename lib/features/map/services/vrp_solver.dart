import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../models/driver_route.dart';
import '../models/geocoded_order.dart';
import '../models/route_stop.dart';
import 'route_optimizer_interface.dart';
import 'osrm_service.dart';

/// Pure-Dart VRP solver using:
/// 1. Greedy nearest-neighbour clustering respecting km cap per driver.
/// 2. Nearest-neighbour TSP to sort stops within each driver's cluster.
/// 3. OSRM for actual road geometry.
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

    // Step 1: cluster orders to drivers
    final clusters = _cluster(
      orders: orders,
      driverCount: driverCount,
      kmCapPerDriver: kmCapPerDriver,
      depot: depot,
    );

    // Step 2: sort each cluster with nearest-neighbour TSP
    final sortedClusters = clusters
        .map((cluster) => _nearestNeighbourTsp(cluster, depot))
        .toList();

    // Step 3: fetch OSRM route geometry per driver
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
        // Fallback: straight lines
        polyline = waypoints;
        distanceKm = _totalHaversineKm(waypoints);
      }

      final stops = cluster.asMap().entries.map((e) {
        return RouteStop(
          stopNumber: e.key + 1,
          order: e.value.order,
          location: e.value.location,
        );
      }).toList();

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

  // ── Greedy nearest-neighbour clustering ──────────────────────────────────

  List<List<GeocodedOrder>> _cluster({
    required List<GeocodedOrder> orders,
    required int driverCount,
    required double kmCapPerDriver,
    required LatLng depot,
  }) {
    final unassigned = List<GeocodedOrder>.from(orders);
    final clusters = List.generate(driverCount, (_) => <GeocodedOrder>[]);
    final usedKm = List.filled(driverCount, 0.0);

    LatLng currentPos(int d) =>
        clusters[d].isEmpty ? depot : clusters[d].last.location;

    while (unassigned.isNotEmpty) {
      bool anyAssigned = false;

      for (int d = 0; d < driverCount; d++) {
        if (usedKm[d] >= kmCapPerDriver) continue;

        // Find nearest unassigned order that fits within km cap
        int bestIdx = -1;
        double bestDist = double.infinity;

        for (int i = 0; i < unassigned.length; i++) {
          final dist = _haversineKm(currentPos(d), unassigned[i].location);
          final returnDist = _haversineKm(unassigned[i].location, depot);
          if (usedKm[d] + dist + returnDist <= kmCapPerDriver &&
              dist < bestDist) {
            bestDist = dist;
            bestIdx = i;
          }
        }

        if (bestIdx >= 0) {
          usedKm[d] += bestDist;
          clusters[d].add(unassigned.removeAt(bestIdx));
          anyAssigned = true;
        }
      }

      // If nothing could be assigned (all caps exceeded), force-assign to
      // driver with most remaining capacity to avoid infinite loop.
      if (!anyAssigned && unassigned.isNotEmpty) {
        final d = _driverWithMostCapacity(usedKm, kmCapPerDriver);
        final order = unassigned.removeAt(0);
        usedKm[d] += _haversineKm(currentPos(d), order.location);
        clusters[d].add(order);
      }
    }

    return clusters;
  }

  int _driverWithMostCapacity(List<double> usedKm, double cap) {
    int best = 0;
    for (int i = 1; i < usedKm.length; i++) {
      if (usedKm[i] < usedKm[best]) best = i;
    }
    return best;
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
}
