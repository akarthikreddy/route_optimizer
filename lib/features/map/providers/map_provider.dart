import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:latlong2/latlong.dart';
import '../models/driver_route.dart';
import '../models/geocoded_order.dart';
import '../models/route_stop.dart';
import '../services/geocoding_service.dart';
import '../services/osrm_service.dart';
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

/// Geocodes all fetched orders. Expensive — cached until orders change.
@riverpod
Future<List<GeocodedOrder>> geocodedOrders(Ref ref) async {
  final orderList = await ref.watch(ordersProvider.future);
  final geocoder = ref.watch(geocodingServiceProvider);

  final geocoded = <GeocodedOrder>[];
  for (final order in orderList) {
    final b = order.billing;
    if (b.city.isEmpty && b.postcode.isEmpty) continue;

    // Build progressively simpler queries — Indian door numbers (e.g.
    // "2-2-1105/80") confuse geocoders so we try without them first.
    final queries = _geocodeQueries(b);
    LatLng? location;
    for (final q in queries) {
      location = await geocoder.geocode(q);
      if (location != null) break;
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

/// Returns queries in order of reliability for Indian addresses.
/// Postcode is the most trustworthy signal — city names are often
/// abbreviated or misspelled (e.g. "Hyder" instead of "Hyderabad").
List<String> _geocodeQueries(WooBilling b) {
  String join(List<String> parts) =>
      parts.where((p) => p.isNotEmpty).join(', ');

  final locality = _stripDoorNumber(b.address1);

  return [
    // 1. Colony/area (address2) + postcode + country
    if (b.address2.isNotEmpty)
      join([b.address2, b.postcode, b.country]),
    // 2. Locality from address1 (door number stripped) + postcode — only if
    //    stripping left something meaningful (more than 3 chars)
    if (locality.isNotEmpty)
      join([locality, b.postcode, b.country]),
    // 3. Postcode + state + country  (Indian pincodes are very specific)
    join([b.postcode, b.state, b.country]),
    // 4. Postcode + country only
    join([b.postcode, b.country]),
    // 5. Last resort: city + state (only if no postcode)
    if (b.postcode.isEmpty) join([b.city, b.state, b.country]),
  ].where((q) => q.isNotEmpty).toList();
}

/// Strips leading door/plot numbers from an Indian address line.
/// e.g. "7-1-32/VL"          → "" (entire token is a door number → skip)
///      "2-2-1105/80, Tilak Nagar" → "Tilak Nagar"
///      "#D 607 Naramada block"    → "Naramada block"
String _stripDoorNumber(String address) {
  // Remove leading door number token: digits/hyphens/slashes + optional letters
  // e.g. "7-1-32/VL" or "2-2-1105/80" or "#D 607"
  final stripped = address
      .replaceFirst(RegExp(r'^#?[\d\-/\\]+[A-Za-z]*\s*,?\s*'), '')
      .replaceFirst(RegExp(r'^#[A-Za-z]\s*\d+\s*,?\s*'), '') // "#D 607 ..."
      .trim();
  // Only return if the result is meaningful (more than 3 characters)
  return stripped.length > 3 ? stripped : '';
}

/// Manages the optimized route state and handles marking stops as delivered.
@riverpod
class RouteState extends _$RouteState {
  @override
  Future<List<DriverRoute>> build() async {
    final geocoded = await ref.watch(geocodedOrdersProvider.future);
    final config = await ref.watch(configProvider.future);
    final solver = ref.watch(vrpSolverProvider);

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
