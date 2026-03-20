import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/woo_order.dart';

class WooCommerceService {
  WooCommerceService({
    required this.baseUrl,
    required this.consumerKey,
    required this.consumerSecret,
  });

  final String baseUrl;
  final String consumerKey;
  final String consumerSecret;

  Map<String, String> get _authParams => {
        'consumer_key': consumerKey,
        'consumer_secret': consumerSecret,
      };

  /// Fetches all orders with status=processing (paginates automatically).
  Future<List<WooOrder>> fetchProcessingOrders() async {
    final orders = <WooOrder>[];
    int page = 1;
    const perPage = 100;

    while (true) {
      final uri = Uri.parse('$baseUrl/wp-json/wc/v3/orders').replace(
        queryParameters: {
          ..._authParams,
          'status': 'processing',
          'per_page': '$perPage',
          'page': '$page',
        },
      );

      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode != 200) {
        throw Exception(
            'WooCommerce error ${response.statusCode}: ${response.body}');
      }

      final batch = (jsonDecode(response.body) as List<dynamic>)
          .map((e) => WooOrder.fromJson(e as Map<String, dynamic>))
          .toList();

      orders.addAll(batch);

      if (batch.length < perPage) break;
      page++;
    }

    return orders;
  }

  /// Updates the order status to "completed".
  Future<void> markAsDelivered(int orderId) async {
    final uri =
        Uri.parse('$baseUrl/wp-json/wc/v3/orders/$orderId').replace(
      queryParameters: _authParams,
    );

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'status': 'completed'}),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to mark order $orderId as delivered: ${response.statusCode}');
    }
  }
}
