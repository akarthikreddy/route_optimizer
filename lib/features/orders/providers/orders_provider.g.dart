// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wooCommerceService)
final wooCommerceServiceProvider = WooCommerceServiceProvider._();

final class WooCommerceServiceProvider extends $FunctionalProvider<
    WooCommerceService,
    WooCommerceService,
    WooCommerceService> with $Provider<WooCommerceService> {
  WooCommerceServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'wooCommerceServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wooCommerceServiceHash();

  @$internal
  @override
  $ProviderElement<WooCommerceService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WooCommerceService create(Ref ref) {
    return wooCommerceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WooCommerceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WooCommerceService>(value),
    );
  }
}

String _$wooCommerceServiceHash() =>
    r'4a2e33e04b2d607fbac8f83f93599444d76a6dc6';

@ProviderFor(orders)
final ordersProvider = OrdersProvider._();

final class OrdersProvider extends $FunctionalProvider<
        AsyncValue<List<WooOrder>>, List<WooOrder>, FutureOr<List<WooOrder>>>
    with $FutureModifier<List<WooOrder>>, $FutureProvider<List<WooOrder>> {
  OrdersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ordersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ordersHash();

  @$internal
  @override
  $FutureProviderElement<List<WooOrder>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<WooOrder>> create(Ref ref) {
    return orders(ref);
  }
}

String _$ordersHash() => r'4953092b794811549450803dc43e8069c9d93b0b';
