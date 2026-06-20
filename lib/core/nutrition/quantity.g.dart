// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quantity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quantity _$QuantityFromJson(Map<String, dynamic> json) => _Quantity(
  amount: (json['amount'] as num).toDouble(),
  measure: $enumDecode(_$QuantityMeasureEnumMap, json['measure']),
);

Map<String, dynamic> _$QuantityToJson(_Quantity instance) => <String, dynamic>{
  'amount': instance.amount,
  'measure': _$QuantityMeasureEnumMap[instance.measure]!,
};

const _$QuantityMeasureEnumMap = {
  QuantityMeasure.grams: 'grams',
  QuantityMeasure.milliliters: 'milliliters',
  QuantityMeasure.servings: 'servings',
};
