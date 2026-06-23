// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  unitSystem: $enumDecode(_$UnitSystemEnumMap, json['unitSystem']),
  vdRegion: $enumDecode(_$VdRegionEnumMap, json['vdRegion']),
  onboardingCompleted: json['onboardingCompleted'] as bool,
  languageCode: json['languageCode'] as String?,
  dailyTarget: json['dailyTarget'] == null
      ? null
      : Nutrients.fromJson(json['dailyTarget'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'unitSystem': _$UnitSystemEnumMap[instance.unitSystem]!,
      'vdRegion': _$VdRegionEnumMap[instance.vdRegion]!,
      'onboardingCompleted': instance.onboardingCompleted,
      'languageCode': instance.languageCode,
      'dailyTarget': instance.dailyTarget?.toJson(),
    };

const _$UnitSystemEnumMap = {
  UnitSystem.metric: 'metric',
  UnitSystem.imperial: 'imperial',
};

const _$VdRegionEnumMap = {
  VdRegion.brazil: 'brazil',
  VdRegion.unitedStates: 'unitedStates',
  VdRegion.europeanUnion: 'europeanUnion',
};
