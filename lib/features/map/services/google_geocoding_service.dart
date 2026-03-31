import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../core/utils/rate_limiter.dart';

/// Geocodes addresses using Google Maps Geocoding API.
/// Uses component filtering for reliable Indian pincode lookup.
class GoogleGeocodingService {
  GoogleGeocodingService({required this.apiKey})
      : _rateLimiter = RateLimiter(maxPerSecond: 10);

  final String apiKey;
  final RateLimiter _rateLimiter;

  static const _baseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';

  /// Geocodes using pincode + country component filter — most reliable for India.
  Future<LatLng?> geocodeByPostalCode(
      String postalCode, String countryCode) async {
    await _rateLimiter.throttle();

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'components': 'postal_code:$postalCode|country:${countryCode.toUpperCase()}',
      'key': apiKey,
    });

    return _fetch(uri);
  }

  /// Geocodes a full address string. Fallback when no postal code.
  Future<LatLng?> geocode(String address) async {
    await _rateLimiter.throttle();

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'address': address,
      'key': apiKey,
    });

    return _fetch(uri);
  }

  Future<LatLng?> _fetch(Uri uri) async {
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final status = data['status'] as String?;
      if (status != 'OK') return null;

      final results = data['results'] as List<dynamic>;
      if (results.isEmpty) return null;

      final loc =
          (results.first as Map<String, dynamic>)['geometry']['location']
              as Map<String, dynamic>;

      return LatLng(
        (loc['lat'] as num).toDouble(),
        (loc['lng'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
