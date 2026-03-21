// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
      wooBaseUrl: json['wooBaseUrl'] as String? ?? '',
      consumerKey: json['consumerKey'] as String? ?? '',
      consumerSecret: json['consumerSecret'] as String? ?? '',
      driverCount: (json['driverCount'] as num?)?.toInt() ?? 3,
      kmCapPerDriver: (json['kmCapPerDriver'] as num?)?.toDouble() ?? 50.0,
    );

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'wooBaseUrl': instance.wooBaseUrl,
      'consumerKey': instance.consumerKey,
      'consumerSecret': instance.consumerSecret,
      'driverCount': instance.driverCount,
      'kmCapPerDriver': instance.kmCapPerDriver,
    };
