import 'package:latlong2/latlong.dart';
import '../models/geocoded_order.dart';
import '../models/driver_route.dart';

/// Abstract interface for route optimization.
/// Implement this to swap in different backends
/// (e.g. Google Route Optimization API, OR-Tools, etc.)
abstract class RouteOptimizerInterface {
  /// Given a list of geocoded orders, return optimized [DriverRoute]s.
  ///
  /// [depot] is the store / warehouse starting location.
  /// [driverCount] is the number of available drivers.
  /// [kmCapPerDriver] is the maximum km each driver can cover.
  Future<List<DriverRoute>> optimize({
    required List<GeocodedOrder> orders,
    required int driverCount,
    required double kmCapPerDriver,
    required LatLng depot,
  });
}
