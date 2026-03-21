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
        AsyncValue<WooCommerceService>,
        WooCommerceService,
        FutureOr<WooCommerceService>>
    with
        $FutureModifier<WooCommerceService>,
        $FutureProvider<WooCommerceService> {
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
  $FutureProviderElement<WooCommerceService> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WooCommerceService> create(Ref ref) {
    return wooCommerceService(ref);
  }
}

String _$wooCommerceServiceHash() =>
    r'b5d27519777274f11765f5a3153e87058663a584';

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

String _$ordersHash() => r'6ff72c19b67310ad1c38b80744a1d7c7da34513a';
