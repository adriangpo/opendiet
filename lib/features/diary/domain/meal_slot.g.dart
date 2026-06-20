// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealSlot _$MealSlotFromJson(Map<String, dynamic> json) => _MealSlot(
  id: json['id'] as String,
  name: json['name'] as String,
  position: (json['position'] as num).toInt(),
);

Map<String, dynamic> _$MealSlotToJson(_MealSlot instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'position': instance.position,
};
