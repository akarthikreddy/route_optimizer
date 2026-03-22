// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geocodingService)
final geocodingServiceProvider = GeocodingServiceProvider._();

final class GeocodingServiceProvider extends $FunctionalProvider<
    GeocodingService,
    GeocodingService,
    GeocodingService> with $Provider<GeocodingService> {
  GeocodingServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'geocodingServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$geocodingServiceHash();

  @$internal
  @override
  $ProviderElement<GeocodingService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GeocodingService create(Ref ref) {
    return geocodingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeocodingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeocodingService>(value),
    );
  }
}

String _$geocodingServiceHash() => r'0789a3c7e6978a17d7e305c6261e3ec1e4fb3285';

@ProviderFor(osrmService)
final osrmServiceProvider = OsrmServiceProvider._();

final class OsrmServiceProvider
    extends $FunctionalProvider<OsrmService, OsrmService, OsrmService>
    with $Provider<OsrmService> {
  OsrmServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'osrmServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$osrmServiceHash();

  @$internal
  @override
  $ProviderElement<OsrmService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OsrmService create(Ref ref) {
    return osrmService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OsrmService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OsrmService>(value),
    );
  }
}

String _$osrmServiceHash() => r'8329d2ee7a45a497e0db20284562ec9e405eb65e';

@ProviderFor(vrpSolver)
final vrpSolverProvider = VrpSolverProvider._();

final class VrpSolverProvider
    extends $FunctionalProvider<VrpSolver, VrpSolver, VrpSolver>
    with $Provider<VrpSolver> {
  VrpSolverProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'vrpSolverProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$vrpSolverHash();

  @$internal
  @override
  $ProviderElement<VrpSolver> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VrpSolver create(Ref ref) {
    return vrpSolver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VrpSolver value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VrpSolver>(value),
    );
  }
}

String _$vrpSolverHash() => r'6335ae86411f2722d954b6bb1158784c879e8b8d';

/// Returns GoogleRouteOptimizer if API key is configured, else VrpSolver.

@ProviderFor(routeOptimizer)
final routeOptimizerProvider = RouteOptimizerProvider._();

/// Returns GoogleRouteOptimizer if API key is configured, else VrpSolver.

final class RouteOptimizerProvider extends $FunctionalProvider<
        AsyncValue<RouteOptimizerInterface>,
        RouteOptimizerInterface,
        FutureOr<RouteOptimizerInterface>>
    with
        $FutureModifier<RouteOptimizerInterface>,
        $FutureProvider<RouteOptimizerInterface> {
  /// Returns GoogleRouteOptimizer if API key is configured, else VrpSolver.
  RouteOptimizerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'routeOptimizerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$routeOptimizerHash();

  @$internal
  @override
  $FutureProviderElement<RouteOptimizerInterface> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RouteOptimizerInterface> create(Ref ref) {
    return routeOptimizer(ref);
  }
}

String _$routeOptimizerHash() => r'c3c79ecd6dc4aa7d8f1e1acd10084c3230c06e8b';

/// Geocodes all fetched orders. Expensive — cached until orders change.

@ProviderFor(geocodedOrders)
final geocodedOrdersProvider = GeocodedOrdersProvider._();

/// Geocodes all fetched orders. Expensive — cached until orders change.

final class GeocodedOrdersProvider extends $FunctionalProvider<
        AsyncValue<List<GeocodedOrder>>,
        List<GeocodedOrder>,
        FutureOr<List<GeocodedOrder>>>
    with
        $FutureModifier<List<GeocodedOrder>>,
        $FutureProvider<List<GeocodedOrder>> {
  /// Geocodes all fetched orders. Expensive — cached until orders change.
  GeocodedOrdersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'geocodedOrdersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$geocodedOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<GeocodedOrder>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<GeocodedOrder>> create(Ref ref) {
    return geocodedOrders(ref);
  }
}

String _$geocodedOrdersHash() => r'b5ac5edd82ceee0d62ef9da6123ec817b0c76c86';

/// Manages the optimized route state and handles marking stops as delivered.

@ProviderFor(RouteState)
final routeStateProvider = RouteStateProvider._();

/// Manages the optimized route state and handles marking stops as delivered.
final class RouteStateProvider
    extends $AsyncNotifierProvider<RouteState, List<DriverRoute>> {
  /// Manages the optimized route state and handles marking stops as delivered.
  RouteStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'routeStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$routeStateHash();

  @$internal
  @override
  RouteState create() => RouteState();
}

String _$routeStateHash() => r'bea400adc464c0785d252a7fd386d69a93f6b744';

/// Manages the optimized route state and handles marking stops as delivered.

abstract class _$RouteState extends $AsyncNotifier<List<DriverRoute>> {
  FutureOr<List<DriverRoute>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<DriverRoute>>, List<DriverRoute>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<DriverRoute>>, List<DriverRoute>>,
        AsyncValue<List<DriverRoute>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
