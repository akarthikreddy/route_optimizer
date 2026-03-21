// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConfigNotifier)
final configProvider = ConfigNotifierProvider._();

final class ConfigNotifierProvider
    extends $AsyncNotifierProvider<ConfigNotifier, AppConfig> {
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

String _$configNotifierHash() => r'ecfcaf8e4c9e1d81b04d3d49ce1f409238fb1342';

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
