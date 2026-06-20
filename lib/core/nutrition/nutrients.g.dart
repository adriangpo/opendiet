// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrients.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Nutrients _$NutrientsFromJson(Map<String, dynamic> json) => _Nutrients(
  energyKcal: (json['energyKcal'] as num?)?.toDouble(),
  carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
  totalSugars: (json['totalSugars'] as num?)?.toDouble(),
  addedSugars: (json['addedSugars'] as num?)?.toDouble(),
  protein: (json['protein'] as num?)?.toDouble(),
  totalFat: (json['totalFat'] as num?)?.toDouble(),
  saturatedFat: (json['saturatedFat'] as num?)?.toDouble(),
  transFat: (json['transFat'] as num?)?.toDouble(),
  dietaryFiber: (json['dietaryFiber'] as num?)?.toDouble(),
  sodiumMilligrams: (json['sodiumMilligrams'] as num?)?.toDouble(),
  micronutrients:
      (json['micronutrients'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const <String, double>{},
);

Map<String, dynamic> _$NutrientsToJson(_Nutrients instance) =>
    <String, dynamic>{
      'energyKcal': instance.energyKcal,
      'carbohydrates': instance.carbohydrates,
      'totalSugars': instance.totalSugars,
      'addedSugars': instance.addedSugars,
      'protein': instance.protein,
      'totalFat': instance.totalFat,
      'saturatedFat': instance.saturatedFat,
      'transFat': instance.transFat,
      'dietaryFiber': instance.dietaryFiber,
      'sodiumMilligrams': instance.sodiumMilligrams,
      'micronutrients': instance.micronutrients,
    };
