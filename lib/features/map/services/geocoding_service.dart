import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../core/utils/rate_limiter.dart';

class GeocodingService {
  GeocodingService() : _rateLimiter = RateLimiter(maxPerSecond: 1);

  final RateLimiter _rateLimiter;

  static const _baseUrl = 'https://nominatim.openstreetmap.org/search';

  /// Geocodes using Nominatim structured parameters.
  /// Uses postalcode + countrycodes for reliable Indian pincode lookup.
  Future<LatLng?> geocodeByPostalCode(String postalCode, String countryCode) async {
    await _rateLimiter.throttle();

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'postalcode': postalCode,
      'countrycodes': countryCode.toLowerCase(),
      'format': 'json',
      'limit': '1',
    });

    return _fetch(uri);
  }

  /// Geocodes a free-form address string. Fallback when no postal code.
  Future<LatLng?> geocode(String address) async {
    await _rateLimiter.throttle();

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': address,
      'format': 'json',
      'limit': '1',
      'addressdetails': '0',
    });

    return _fetch(uri);
  }

  Future<LatLng?> _fetch(Uri uri) async {
    try {
      final response = await http.get(uri, headers: {
        'User-Agent': 'RouteOptimizer/1.0 (internal delivery app)',
        'Accept': 'application/json',
      });

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as List<dynamic>;
      if (data.isEmpty) return null;

      final first = data.first as Map<String, dynamic>;
      final lat = double.tryParse(first['lat'] as String? ?? '');
      final lon = double.tryParse(first['lon'] as String? ?? '');

      if (lat == null || lon == null) return null;
      return LatLng(lat, lon);
    } catch (_) {
      return null;
    }
  }
}
