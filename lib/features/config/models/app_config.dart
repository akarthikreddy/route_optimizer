import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    @Default('') String wooBaseUrl,
    @Default('') String consumerKey,
    @Default('') String consumerSecret,
    @Default(3) int driverCount,
    @Default(50.0) double kmCapPerDriver,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}
