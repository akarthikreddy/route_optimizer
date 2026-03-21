import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/woo_order.dart';
import '../services/woocommerce_service.dart';
import '../../config/providers/config_provider.dart';

part 'orders_provider.g.dart';

@riverpod
WooCommerceService wooCommerceService(Ref ref) {
  final config = ref.watch(configProvider).value;
  if (config == null) {
    throw StateError('Config not loaded');
  }
  return WooCommerceService(
    baseUrl: config.wooBaseUrl,
    consumerKey: config.consumerKey,
    consumerSecret: config.consumerSecret,
  );
}

@riverpod
Future<List<WooOrder>> orders(Ref ref) async {
  final service = ref.watch(wooCommerceServiceProvider);
  return service.fetchProcessingOrders();
}
