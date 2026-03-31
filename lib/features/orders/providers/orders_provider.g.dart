// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wooCommerceService)
final wooCommerceServiceProvider = WooCommerceServiceProvider._();

final class WooCommerceServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<WooCommerceService>,
          WooCommerceService,
          FutureOr<WooCommerceService>
        >
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WooCommerceService> create(Ref ref) {
    return wooCommerceService(ref);
  }
}

String _$wooCommerceServiceHash() =>
    r'b5d27519777274f11765f5a3153e87058663a584';

/// All processing orders from WooCommerce (unfiltered).

@ProviderFor(orders)
final ordersProvider = OrdersProvider._();

/// All processing orders from WooCommerce (unfiltered).

final class OrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WooOrder>>,
          List<WooOrder>,
          FutureOr<List<WooOrder>>
        >
    with $FutureModifier<List<WooOrder>>, $FutureProvider<List<WooOrder>> {
  /// All processing orders from WooCommerce (unfiltered).
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WooOrder>> create(Ref ref) {
    return orders(ref);
  }
}

String _$ordersHash() => r'6ff72c19b67310ad1c38b80744a1d7c7da34513a';

/// All unique delivery slots found across all orders, sorted chronologically.

@ProviderFor(availableSlots)
final availableSlotsProvider = AvailableSlotsProvider._();

/// All unique delivery slots found across all orders, sorted chronologically.

final class AvailableSlotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// All unique delivery slots found across all orders, sorted chronologically.
  AvailableSlotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableSlotsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableSlotsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return availableSlots(ref);
  }
}

String _$availableSlotsHash() => r'cb934eab7dd5eff7063e00530d9f952e9c6018eb';

/// The nearest upcoming slot (today or first future slot).

@ProviderFor(nearestSlot)
final nearestSlotProvider = NearestSlotProvider._();

/// The nearest upcoming slot (today or first future slot).

final class NearestSlotProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The nearest upcoming slot (today or first future slot).
  NearestSlotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearestSlotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearestSlotHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return nearestSlot(ref);
  }
}

String _$nearestSlotHash() => r'771f7e3c80a1a6b9f9137b540c35b863d6fd1ccb';

/// Selected slots for filtering. Empty set = show all orders.

@ProviderFor(SelectedSlots)
final selectedSlotsProvider = SelectedSlotsProvider._();

/// Selected slots for filtering. Empty set = show all orders.
final class SelectedSlotsProvider
    extends $NotifierProvider<SelectedSlots, Set<String>> {
  /// Selected slots for filtering. Empty set = show all orders.
  SelectedSlotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSlotsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSlotsHash();

  @$internal
  @override
  SelectedSlots create() => SelectedSlots();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$selectedSlotsHash() => r'a6c507d1636d8ba06c2cbf5f07de1d18dac3524d';

/// Selected slots for filtering. Empty set = show all orders.

abstract class _$SelectedSlots extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Whether the slot filter has been initialised with the nearest slot.

@ProviderFor(SlotInitialised)
final slotInitialisedProvider = SlotInitialisedProvider._();

/// Whether the slot filter has been initialised with the nearest slot.
final class SlotInitialisedProvider
    extends $NotifierProvider<SlotInitialised, bool> {
  /// Whether the slot filter has been initialised with the nearest slot.
  SlotInitialisedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'slotInitialisedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$slotInitialisedHash();

  @$internal
  @override
  SlotInitialised create() => SlotInitialised();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$slotInitialisedHash() => r'2571b9d97a335a9a9753eb695f5ff46c64d879ae';

/// Whether the slot filter has been initialised with the nearest slot.

abstract class _$SlotInitialised extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Orders filtered by selected slots (empty set = all orders).

@ProviderFor(filteredOrders)
final filteredOrdersProvider = FilteredOrdersProvider._();

/// Orders filtered by selected slots (empty set = all orders).

final class FilteredOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WooOrder>>,
          List<WooOrder>,
          FutureOr<List<WooOrder>>
        >
    with $FutureModifier<List<WooOrder>>, $FutureProvider<List<WooOrder>> {
  /// Orders filtered by selected slots (empty set = all orders).
  FilteredOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<WooOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WooOrder>> create(Ref ref) {
    return filteredOrders(ref);
  }
}

String _$filteredOrdersHash() => r'6736cb485f78b0a92cde97eacd79012352929636';
