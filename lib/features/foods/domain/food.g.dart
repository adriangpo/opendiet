// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Food _$FoodFromJson(Map<String, dynamic> json) => _Food(
  id: json['id'] as String,
  name: json['name'] as String,
  source: $enumDecode(_$FoodSourceEnumMap, json['source']),
  basis: $enumDecode(_$NutrientBasisEnumMap, json['basis']),
  nutrients: Nutrients.fromJson(json['nutrients'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  brand: json['brand'] as String?,
  barcode: json['barcode'] as String?,
  servingSizeMetric: (json['servingSizeMetric'] as num?)?.toDouble(),
  servingUnit: $enumDecodeNullable(_$ServingUnitEnumMap, json['servingUnit']),
  householdMeasure: json['householdMeasure'] as String?,
  energyIsManual: json['energyIsManual'] as bool? ?? false,
);

Map<String, dynamic> _$FoodToJson(_Food instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'source': _$FoodSourceEnumMap[instance.source]!,
  'basis': _$NutrientBasisEnumMap[instance.basis]!,
  'nutrients': instance.nutrients.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'brand': instance.brand,
  'barcode': instance.barcode,
  'servingSizeMetric': instance.servingSizeMetric,
  'servingUnit': _$ServingUnitEnumMap[instance.servingUnit],
  'householdMeasure': instance.householdMeasure,
  'energyIsManual': instance.energyIsManual,
};

const _$FoodSourceEnumMap = {
  FoodSource.custom: 'custom',
  FoodSource.openFoodFacts: 'openFoodFacts',
  FoodSource.imported: 'imported',
};

const _$NutrientBasisEnumMap = {
  NutrientBasis.per100g: 'per100g',
  NutrientBasis.per100ml: 'per100ml',
  NutrientBasis.perServing: 'perServing',
};

const _$ServingUnitEnumMap = {
  ServingUnit.gram: 'gram',
  ServingUnit.milliliter: 'milliliter',
  ServingUnit.piece: 'piece',
};
