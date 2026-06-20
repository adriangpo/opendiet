// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryEntry _$DiaryEntryFromJson(Map<String, dynamic> json) => _DiaryEntry(
  id: json['id'] as String,
  day: DateTime.parse(json['day'] as String),
  mealSlotId: json['mealSlotId'] as String,
  referenceKind: $enumDecode(
    _$DiaryReferenceKindEnumMap,
    json['referenceKind'],
  ),
  label: json['label'] as String,
  quantity: Quantity.fromJson(json['quantity'] as Map<String, dynamic>),
  nutrients: Nutrients.fromJson(json['nutrients'] as Map<String, dynamic>),
  loggedAt: DateTime.parse(json['loggedAt'] as String),
  referenceId: json['referenceId'] as String?,
);

Map<String, dynamic> _$DiaryEntryToJson(_DiaryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day.toIso8601String(),
      'mealSlotId': instance.mealSlotId,
      'referenceKind': _$DiaryReferenceKindEnumMap[instance.referenceKind]!,
      'label': instance.label,
      'quantity': instance.quantity.toJson(),
      'nutrients': instance.nutrients.toJson(),
      'loggedAt': instance.loggedAt.toIso8601String(),
      'referenceId': instance.referenceId,
    };

const _$DiaryReferenceKindEnumMap = {
  DiaryReferenceKind.food: 'food',
  DiaryReferenceKind.recipe: 'recipe',
  DiaryReferenceKind.quickAdd: 'quickAdd',
};
