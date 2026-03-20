import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsrmRouteResult {
  const OsrmRouteResult({
    required this.geometry,
    required this.distanceKm,
    required this.durationSec,
  });

  final List<LatLng> geometry;
  final double distanceKm;
  final double durationSec;
}

class OsrmService {
  static const _baseUrl = 'http://router.project-osrm.org';

  /// Fetches the route geometry and distance for an ordered list of waypoints.
  Future<OsrmRouteResult> getRoute(List<LatLng> waypoints) async {
    if (waypoints.length < 2) {
      throw ArgumentError('At least 2 waypoints required');
    }

    final coords = waypoints
        .map((p) => '${p.longitude},${p.latitude}')
        .join(';');

    final uri = Uri.parse('$_baseUrl/route/v1/driving/$coords').replace(
      queryParameters: {
        'overview': 'full',
        'geometries': 'geojson',
        'steps': 'false',
      },
    );

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('OSRM error ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['code'] != 'Ok') {
      throw Exception('OSRM returned: ${data['code']}');
    }

    final route = (data['routes'] as List).first as Map<String, dynamic>;
    final distanceM = (route['distance'] as num).toDouble();
    final duration = (route['duration'] as num).toDouble();

    final coordinates =
        (route['geometry']['coordinates'] as List<dynamic>).map((c) {
      final coords = c as List<dynamic>;
      return LatLng(
        (coords[1] as num).toDouble(),
        (coords[0] as num).toDouble(),
      );
    }).toList();

    return OsrmRouteResult(
      geometry: coordinates,
      distanceKm: distanceM / 1000,
      durationSec: duration,
    );
  }
}
