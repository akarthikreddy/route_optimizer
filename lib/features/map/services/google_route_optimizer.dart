import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../models/driver_route.dart';
import '../models/geocoded_order.dart';
import '../models/route_stop.dart';
import 'route_optimizer_interface.dart';

/// Calls Google Cloud Route Optimization API (v1 optimizeTours).
///
/// Setup:
/// 1. Enable "Route Optimization API" in Google Cloud Console.
/// 2. Create an API key restricted to Route Optimization API.
/// 3. Fill google_api_key and google_project_id in assets/woo_config.json.
///
/// Docs: https://cloud.google.com/route-optimization/docs
class GoogleRouteOptimizer implements RouteOptimizerInterface {
  const GoogleRouteOptimizer({
    required this.apiKey,
    required this.projectId,
  });

  final String apiKey;
  final String projectId;

  static const _baseUrl = 'https://routeoptimization.googleapis.com';

  @override
  Future<List<DriverRoute>> optimize({
    required List<GeocodedOrder> orders,
    required int driverCount,
    required double kmCapPerDriver,
    required LatLng depot,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/v1/projects/$projectId:optimizeTours?key=$apiKey',
    );

    final body = _buildRequest(
      orders: orders,
      driverCount: driverCount,
      kmCapPerDriver: kmCapPerDriver,
      depot: depot,
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final err = jsonDecode(response.body);
      throw Exception(
        'Google Route Optimization error ${response.statusCode}: '
        '${err['error']?['message'] ?? response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return _parseResponse(data, orders, depot);
  }

  // ── Request builder ────────────────────────────────────────────────────────

  Map<String, dynamic> _buildRequest({
    required List<GeocodedOrder> orders,
    required int driverCount,
    required double kmCapPerDriver,
    required LatLng depot,
  }) {
    final depotWaypoint = {
      'location': {
        'latLng': {'latitude': depot.latitude, 'longitude': depot.longitude}
      }
    };

    final shipments = orders.asMap().entries.map((e) {
      final order = e.value;
      return {
        'label': '${order.order.id}',
        'deliveries': [
          {
            'arrivalLocation': {
              'latitude': order.location.latitude,
              'longitude': order.location.longitude,
            },
            // 3-minute service time per stop
            'duration': '180s',
          }
        ],
      };
    }).toList();

    final vehicles = List.generate(driverCount, (i) {
      return {
        'label': 'driver_${i + 1}',
        'startWaypoint': depotWaypoint,
        'endWaypoint': depotWaypoint,
        'routeDistanceLimit': {
          'maxMeters': (kmCapPerDriver * 1000).toInt(),
        },
        'costPerKilometer': 1.0,
      };
    });

    return {
      'model': {
        'shipments': shipments,
        'vehicles': vehicles,
        'globalDurationCostPerHour': 1.0,
      },
      'populatePolylines': true,
      'considerRoadTraffic': false,
    };
  }

  // ── Response parser ────────────────────────────────────────────────────────

  List<DriverRoute> _parseResponse(
    Map<String, dynamic> data,
    List<GeocodedOrder> orders,
    LatLng depot,
  ) {
    final apiRoutes = data['routes'] as List<dynamic>? ?? [];
    final routes = <DriverRoute>[];

    for (int i = 0; i < apiRoutes.length; i++) {
      final apiRoute = apiRoutes[i] as Map<String, dynamic>;
      final visits = apiRoute['visits'] as List<dynamic>? ?? [];

      if (visits.isEmpty) continue;

      // Map shipment index → order
      final stops = <RouteStop>[];
      for (int s = 0; s < visits.length; s++) {
        final visit = visits[s] as Map<String, dynamic>;
        final shipmentIdx = visit['shipmentIndex'] as int? ?? 0;
        if (shipmentIdx >= orders.length) continue;

        stops.add(RouteStop(
          stopNumber: s + 1,
          order: orders[shipmentIdx].order,
          location: orders[shipmentIdx].location,
        ));
      }

      // Decode polyline if present
      final polylineData = apiRoute['routePolyline'] as Map<String, dynamic>?;
      final encodedPolyline = polylineData?['points'] as String?;
      final polyline = encodedPolyline != null
          ? _decodePolyline(encodedPolyline)
          : [depot, ...stops.map((s) => s.location)];

      // Extract distance
      final metrics = apiRoute['metrics'] as Map<String, dynamic>?;
      final distM =
          (metrics?['travelDistanceMeters'] as num?)?.toDouble() ?? 0;

      routes.add(DriverRoute(
        driverIndex: i,
        color: AppColors.driverColor(i),
        stops: stops,
        polyline: polyline,
        totalDistanceKm: distM / 1000,
      ));
    }

    return routes;
  }

  // ── Encoded polyline decoder (Google's format) ────────────────────────────

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dLat = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dLng = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lng += dLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
