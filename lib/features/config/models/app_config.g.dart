// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
      storeLat: (json['storeLat'] as num?)?.toDouble() ?? 0.0,
      storeLng: (json['storeLng'] as num?)?.toDouble() ?? 0.0,
      driverCount: (json['driverCount'] as num?)?.toInt() ?? 3,
      kmCapPerDriver: (json['kmCapPerDriver'] as num?)?.toDouble() ?? 50.0,
    );

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'storeLat': instance.storeLat,
      'storeLng': instance.storeLng,
      'driverCount': instance.driverCount,
      'kmCapPerDriver': instance.kmCapPerDriver,
    };
