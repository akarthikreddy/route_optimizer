import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../models/driver_route.dart';
import '../models/geocoded_order.dart';
import '../models/route_stop.dart';
import 'route_optimizer_interface.dart';
import 'osrm_service.dart';

/// VRP Solver using:
/// 1. K-means geographic clustering — groups spatially close orders to the
///    same driver, preventing two drivers from covering the same neighbourhood.
/// 2. Nearest-neighbour TSP to sort stops within each cluster.
/// 3. OSRM for real road geometry.
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

    // Step 1: k-means clustering
    final clusters = _kMeansCluster(
      orders: orders,
      k: k,
      depot: depot,
      kmCapPerDriver: kmCapPerDriver,
    );

    // Step 2: nearest-neighbour TSP within each cluster
    final sortedClusters =
        clusters.map((c) => _nearestNeighbourTsp(c, depot)).toList();

    // Step 3: fetch OSRM geometry per driver
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

  // ── K-means geographic clustering ─────────────────────────────────────────

  List<List<GeocodedOrder>> _kMeansCluster({
    required List<GeocodedOrder> orders,
    required int k,
    required LatLng depot,
    required double kmCapPerDriver,
  }) {
    // Initialise centroids using max-spread: each new centroid is the order
    // farthest from all existing centroids, ensuring drivers cover different
    // geographic areas from the start.
    final centroids = _initCentroids(orders, k);
    final assignments = List.filled(orders.length, 0);

    // Run up to 100 iterations or until assignments stabilise
    for (int iter = 0; iter < 100; iter++) {
      bool changed = false;

      for (int i = 0; i < orders.length; i++) {
        int nearest = 0;
        double nearestDist = double.infinity;
        for (int j = 0; j < k; j++) {
          final d = _haversineKm(orders[i].location, centroids[j]);
          if (d < nearestDist) {
            nearestDist = d;
            nearest = j;
          }
        }
        if (assignments[i] != nearest) {
          assignments[i] = nearest;
          changed = true;
        }
      }

      if (!changed) break;

      // Recompute centroids as geographic mean of assigned orders
      for (int j = 0; j < k; j++) {
        final members = <GeocodedOrder>[];
        for (int i = 0; i < orders.length; i++) {
          if (assignments[i] == j) members.add(orders[i]);
        }
        if (members.isEmpty) continue;
        final avgLat =
            members.map((o) => o.location.latitude).reduce((a, b) => a + b) /
                members.length;
        final avgLng =
            members.map((o) => o.location.longitude).reduce((a, b) => a + b) /
                members.length;
        centroids[j] = LatLng(avgLat, avgLng);
      }
    }

    // Build raw clusters
    final clusters = List.generate(k, (_) => <GeocodedOrder>[]);
    for (int i = 0; i < orders.length; i++) {
      clusters[assignments[i]].add(orders[i]);
    }

    // Enforce km cap: move overflowing orders to the nearest other cluster
    _enforceKmCap(
      clusters: clusters,
      depot: depot,
      kmCapPerDriver: kmCapPerDriver,
    );

    return clusters;
  }

  /// Initialises k centroids using max-spread selection (similar to k-means++).
  /// Each new centroid is the order farthest from all already-chosen centroids.
  List<LatLng> _initCentroids(List<GeocodedOrder> orders, int k) {
    final centroids = <LatLng>[];

    // Start with the order farthest from the first order (creates spread)
    centroids.add(orders.first.location);

    while (centroids.length < k) {
      GeocodedOrder? farthest;
      double maxMinDist = -1;

      for (final o in orders) {
        // Min distance from this order to any existing centroid
        final minDist = centroids
            .map((c) => _haversineKm(o.location, c))
            .reduce(min);
        if (minDist > maxMinDist) {
          maxMinDist = minDist;
          farthest = o;
        }
      }

      if (farthest != null) centroids.add(farthest.location);
    }

    return centroids;
  }

  /// Moves orders from over-capacity clusters to the nearest cluster that
  /// still has room, so no driver exceeds their km cap.
  void _enforceKmCap({
    required List<List<GeocodedOrder>> clusters,
    required LatLng depot,
    required double kmCapPerDriver,
  }) {
    bool overflow = true;
    int safetyLimit = clusters.length * 10;

    while (overflow && safetyLimit-- > 0) {
      overflow = false;

      for (int i = 0; i < clusters.length; i++) {
        final routeKm = _clusterKm(clusters[i], depot);
        if (routeKm <= kmCapPerDriver) continue;

        overflow = true;

        // Find the order in this cluster whose removal saves the most km
        int worstIdx = _mostExpensiveOrderIndex(clusters[i], depot);
        final order = clusters[i].removeAt(worstIdx);

        // Move it to the cluster (≠ i) whose centroid is nearest to this order
        int bestCluster = -1;
        double bestDist = double.infinity;
        for (int j = 0; j < clusters.length; j++) {
          if (j == i) continue;
          final targetKm = _clusterKm(clusters[j], depot) +
              _haversineKm(order.location, depot);
          if (targetKm <= kmCapPerDriver * 1.1) {
            // 10% tolerance to avoid infinite loops
            final d = _centroidDist(clusters[j], order.location);
            if (d < bestDist) {
              bestDist = d;
              bestCluster = j;
            }
          }
        }

        // If no cluster fits, just add to the least-loaded one
        if (bestCluster == -1) {
          bestCluster = _leastLoadedCluster(clusters, depot, i);
        }

        clusters[bestCluster].add(order);
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

  // ── Helpers ───────────────────────────────────────────────────────────────

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

  /// Estimates total route km for a cluster (depot → stops → depot).
  double _clusterKm(List<GeocodedOrder> cluster, LatLng depot) {
    if (cluster.isEmpty) return 0;
    final points = [depot, ...cluster.map((o) => o.location), depot];
    return _totalHaversineKm(points);
  }

  /// Returns the index of the order whose removal reduces route km the most.
  int _mostExpensiveOrderIndex(List<GeocodedOrder> cluster, LatLng depot) {
    final baseKm = _clusterKm(cluster, depot);
    int worstIdx = 0;
    double maxSaving = -1;

    for (int i = 0; i < cluster.length; i++) {
      final without = [...cluster]..removeAt(i);
      final saving = baseKm - _clusterKm(without, depot);
      if (saving > maxSaving) {
        maxSaving = saving;
        worstIdx = i;
      }
    }
    return worstIdx;
  }

  double _centroidDist(List<GeocodedOrder> cluster, LatLng point) {
    if (cluster.isEmpty) return double.infinity;
    final avgLat =
        cluster.map((o) => o.location.latitude).reduce((a, b) => a + b) /
            cluster.length;
    final avgLng =
        cluster.map((o) => o.location.longitude).reduce((a, b) => a + b) /
            cluster.length;
    return _haversineKm(LatLng(avgLat, avgLng), point);
  }

  int _leastLoadedCluster(
      List<List<GeocodedOrder>> clusters, LatLng depot, int exclude) {
    int best = exclude == 0 ? 1 : 0;
    double minKm = double.infinity;
    for (int j = 0; j < clusters.length; j++) {
      if (j == exclude) continue;
      final km = _clusterKm(clusters[j], depot);
      if (km < minKm) {
        minKm = km;
        best = j;
      }
    }
    return best;
  }
}
