import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../models/driver_route.dart';
import '../models/geocoded_order.dart';
import '../models/route_stop.dart';
import '../services/geocoding_service.dart';
import '../services/google_geocoding_service.dart';
import '../services/google_route_optimizer.dart';
import '../services/osrm_service.dart';
import '../services/route_optimizer_interface.dart';
import '../services/vrp_solver.dart';
import '../../config/providers/config_provider.dart';
import '../../orders/models/woo_order.dart';
import '../../orders/providers/orders_provider.dart';

part 'map_provider.g.dart';

@riverpod
GeocodingService geocodingService(Ref ref) => GeocodingService();

@riverpod
OsrmService osrmService(Ref ref) => OsrmService();

@riverpod
VrpSolver vrpSolver(Ref ref) =>
    VrpSolver(osrmService: ref.watch(osrmServiceProvider));

/// Returns GoogleRouteOptimizer if API key is configured, else VrpSolver.
@riverpod
Future<RouteOptimizerInterface> routeOptimizer(Ref ref) async {
  final wooConfig = await ref.watch(wooConfigProvider.future);
  if (wooConfig.useGoogleOptimizer) {
    return GoogleRouteOptimizer(projectId: wooConfig.googleProjectId);
  }
  return ref.watch(vrpSolverProvider);
}

/// Geocodes all fetched orders. Expensive — cached until orders change.
@riverpod
Future<List<GeocodedOrder>> geocodedOrders(Ref ref) async {
  final orderList = await ref.watch(filteredOrdersProvider.future);
  final wooConfig = await ref.watch(wooConfigProvider.future);

  // Use Google Geocoding when API key is available — much more accurate for India.
  final GoogleGeocodingService? googleGeocoder = wooConfig.googleApiKey.isNotEmpty
      ? GoogleGeocodingService(apiKey: wooConfig.googleApiKey)
      : null;
  final nominatimGeocoder = ref.watch(geocodingServiceProvider);

  final geocoded = <GeocodedOrder>[];
  for (final order in orderList) {
    final b = order.billing;
    if (b.city.isEmpty && b.postcode.isEmpty) continue;

    LatLng? location;
    final country = b.country.isNotEmpty ? b.country : 'IN';

    if (googleGeocoder != null) {
      // Google: full address first for building-level accuracy,
      // then pincode centroid as fallback.
      if (b.address1.isNotEmpty || b.city.isNotEmpty) {
        final parts = [b.address1, b.city, b.state, b.postcode, country]
            .where((p) => p.isNotEmpty);
        location = await googleGeocoder.geocode(parts.join(', '));
      }
      if (location == null && b.postcode.isNotEmpty) {
        location = await googleGeocoder.geocodeByPostalCode(b.postcode, country);
      }
      // If Google failed entirely, fall back to Nominatim.
      if (location == null && b.postcode.isNotEmpty) {
        location = await nominatimGeocoder.geocodeByPostalCode(
            b.postcode, country.toLowerCase());
      }
    } else {
      // Nominatim: structured postalcode lookup, then city fallback.
      if (b.postcode.isNotEmpty) {
        location = await nominatimGeocoder.geocodeByPostalCode(
            b.postcode, country.toLowerCase());
      }
      if (location == null && b.city.isNotEmpty) {
        final parts = [b.city, b.state, b.country].where((p) => p.isNotEmpty);
        location = await nominatimGeocoder.geocode(parts.join(', '));
      }
    }

    if (location != null) {
      geocoded.add(GeocodedOrder(order: order, location: location));
    }
  }

  if (geocoded.isEmpty && orderList.isNotEmpty) {
    throw Exception(
      'Could not geocode any of the ${orderList.length} order addresses. '
      'Check that billing addresses have a valid city and postcode in WooCommerce.',
    );
  }

  return geocoded;
}


/// Manages the optimized route state and handles marking stops as delivered.
@riverpod
class RouteState extends _$RouteState {
  @override
  Future<List<DriverRoute>> build() async {
    final geocoded = await ref.watch(geocodedOrdersProvider.future);
    final config = await ref.watch(configProvider.future);
    final solver = await ref.watch(routeOptimizerProvider.future);

    if (geocoded.isEmpty) return [];

    final depot = LatLng(config.storeLat, config.storeLng);

    return solver.optimize(
      orders: geocoded,
      driverCount: config.driverCount,
      kmCapPerDriver: config.kmCapPerDriver,
      depot: depot,
    );
  }

  Future<void> markAsDelivered({
    required int driverIndex,
    required int stopIndex,
  }) async {
    final routes = state.value;
    if (routes == null) return;

    final driver = routes[driverIndex];
    final stop = driver.stops[stopIndex];

    final service = await ref.read(wooCommerceServiceProvider.future);
    await service.markAsDelivered(stop.order.id);

    final updatedStops = List<RouteStop>.from(driver.stops);
    updatedStops[stopIndex] = stop.copyWith(isDelivered: true);

    final updatedRoutes = List<DriverRoute>.from(routes);
    updatedRoutes[driverIndex] = driver.copyWith(stops: updatedStops);

    state = AsyncData(updatedRoutes);
  }
}
