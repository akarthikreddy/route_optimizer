import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_config.dart';

part 'config_provider.g.dart';

const _kConfigKey = 'app_config';

@Riverpod(keepAlive: true)
class ConfigNotifier extends _$ConfigNotifier {
  @override
  Future<AppConfig> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kConfigKey);
    if (raw == null) return const AppConfig();
    try {
      return AppConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const AppConfig();
    }
  }

  Future<void> save(AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kConfigKey, jsonEncode(config.toJson()));
    state = AsyncData(config);
  }

  bool get isConfigured {
    final cfg = state.valueOrNull;
    if (cfg == null) return false;
    return cfg.wooBaseUrl.isNotEmpty &&
        cfg.consumerKey.isNotEmpty &&
        cfg.consumerSecret.isNotEmpty;
  }
}
