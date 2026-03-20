import 'package:latlong2/latlong.dart';
import '../../orders/models/woo_order.dart';

class RouteStop {
  RouteStop({
    required this.stopNumber,
    required this.order,
    required this.location,
    this.isDelivered = false,
  });

  final int stopNumber;
  final WooOrder order;
  final LatLng location;
  bool isDelivered;

  RouteStop copyWith({bool? isDelivered}) => RouteStop(
        stopNumber: stopNumber,
        order: order,
        location: location,
        isDelivered: isDelivered ?? this.isDelivered,
      );
}
