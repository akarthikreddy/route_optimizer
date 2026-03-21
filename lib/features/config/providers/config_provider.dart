import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_config.dart';
import '../models/woo_config.dart';

part 'config_provider.g.dart';

const _kConfigKey = 'app_config';

/// Loads WooCommerce credentials from the bundled assets/woo_config.json.
@Riverpod(keepAlive: true)
Future<WooConfig> wooConfig(Ref ref) async {
  final raw = await rootBundle.loadString('assets/woo_config.json');
  return WooConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

/// Stores user-entered settings (store location, driver config) on device.
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
    final cfg = state.value;
    if (cfg == null) return false;
    return cfg.storeLat != 0.0 && cfg.storeLng != 0.0;
  }
}
