import 'package:latlong2/latlong.dart';
import '../../orders/models/woo_order.dart';

class GeocodedOrder {
  const GeocodedOrder({
    required this.order,
    required this.location,
  });

  final WooOrder order;
  final LatLng location;
}
