import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/woo_order.dart';
import '../services/woocommerce_service.dart';
import '../../config/providers/config_provider.dart';

part 'orders_provider.g.dart';

@riverpod
Future<WooCommerceService> wooCommerceService(Ref ref) async {
  final wooConfig = await ref.watch(wooConfigProvider.future);
  return WooCommerceService(
    baseUrl: wooConfig.baseUrl,
    consumerKey: wooConfig.consumerKey,
    consumerSecret: wooConfig.consumerSecret,
  );
}

@riverpod
Future<List<WooOrder>> orders(Ref ref) async {
  final service = await ref.watch(wooCommerceServiceProvider.future);
  return service.fetchProcessingOrders();
}
