// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads WooCommerce credentials from the bundled assets/woo_config.json.

@ProviderFor(wooConfig)
final wooConfigProvider = WooConfigProvider._();

/// Loads WooCommerce credentials from the bundled assets/woo_config.json.

final class WooConfigProvider extends $FunctionalProvider<AsyncValue<WooConfig>,
        WooConfig, FutureOr<WooConfig>>
    with $FutureModifier<WooConfig>, $FutureProvider<WooConfig> {
  /// Loads WooCommerce credentials from the bundled assets/woo_config.json.
  WooConfigProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'wooConfigProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wooConfigHash();

  @$internal
  @override
  $FutureProviderElement<WooConfig> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WooConfig> create(Ref ref) {
    return wooConfig(ref);
  }
}

String _$wooConfigHash() => r'8b9bfe1d0fe429a22a3123abf6b76654eb58e07c';

/// Stores user-entered settings (store location, driver config) on device.

@ProviderFor(ConfigNotifier)
final configProvider = ConfigNotifierProvider._();

/// Stores user-entered settings (store location, driver config) on device.
final class ConfigNotifierProvider
    extends $AsyncNotifierProvider<ConfigNotifier, AppConfig> {
  /// Stores user-entered settings (store location, driver config) on device.
  ConfigNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'configProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$configNotifierHash();

  @$internal
  @override
  ConfigNotifier create() => ConfigNotifier();
}

String _$configNotifierHash() => r'e870282c602e04e7b425a73f2362a3998bb64e31';

/// Stores user-entered settings (store location, driver config) on device.

abstract class _$ConfigNotifier extends $AsyncNotifier<AppConfig> {
  FutureOr<AppConfig> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppConfig>, AppConfig>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AppConfig>, AppConfig>,
        AsyncValue<AppConfig>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
