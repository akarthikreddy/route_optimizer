import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/woo_order.dart';
import '../services/woocommerce_service.dart';
import '../../config/providers/config_provider.dart';

part 'orders_provider.g.dart';

@riverpod
WooCommerceService wooCommerceService(WooCommerceServiceRef ref) {
  final config = ref.watch(configNotifierProvider).valueOrNull;
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
Future<List<WooOrder>> orders(OrdersRef ref) async {
  final service = ref.watch(wooCommerceServiceProvider);
  return service.fetchProcessingOrders();
}
