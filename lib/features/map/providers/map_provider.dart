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
    final address = order.billing.fullAddress;
    if (address.isEmpty) continue;

    final location = await geocoder.geocode(address);
    if (location != null) {
      geocoded.add(GeocodedOrder(order: order, location: location));
    }
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
