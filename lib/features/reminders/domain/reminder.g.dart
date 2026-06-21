// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: json['id'] as String,
  hour: (json['hour'] as num).toInt(),
  minute: (json['minute'] as num).toInt(),
  enabled: json['enabled'] as bool,
  mealSlotId: json['mealSlotId'] as String?,
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'hour': instance.hour,
  'minute': instance.minute,
  'enabled': instance.enabled,
  'mealSlotId': instance.mealSlotId,
};
