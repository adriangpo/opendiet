// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Food {

 String get id; String get name; FoodSource get source; NutrientBasis get basis; Nutrients get nutrients; DateTime get createdAt; DateTime get updatedAt; String? get brand; String? get barcode; double? get servingSizeMetric; ServingUnit? get servingUnit; String? get householdMeasure; bool get energyIsManual; DateTime? get lastLoggedAt; bool get isFavorite;
/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCopyWith<Food> get copyWith => _$FoodCopyWithImpl<Food>(this as Food, _$identity);

  /// Serializes this Food to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Food&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.nutrients, nutrients) || other.nutrients == nutrients)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.servingSizeMetric, servingSizeMetric) || other.servingSizeMetric == servingSizeMetric)&&(identical(other.servingUnit, servingUnit) || other.servingUnit == servingUnit)&&(identical(other.householdMeasure, householdMeasure) || other.householdMeasure == householdMeasure)&&(identical(other.energyIsManual, energyIsManual) || other.energyIsManual == energyIsManual)&&(identical(other.lastLoggedAt, lastLoggedAt) || other.lastLoggedAt == lastLoggedAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,source,basis,nutrients,createdAt,updatedAt,brand,barcode,servingSizeMetric,servingUnit,householdMeasure,energyIsManual,lastLoggedAt,isFavorite);

@override
String toString() {
  return 'Food(id: $id, name: $name, source: $source, basis: $basis, nutrients: $nutrients, createdAt: $createdAt, updatedAt: $updatedAt, brand: $brand, barcode: $barcode, servingSizeMetric: $servingSizeMetric, servingUnit: $servingUnit, householdMeasure: $householdMeasure, energyIsManual: $energyIsManual, lastLoggedAt: $lastLoggedAt, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $FoodCopyWith<$Res>  {
  factory $FoodCopyWith(Food value, $Res Function(Food) _then) = _$FoodCopyWithImpl;
@useResult
$Res call({
 String id, String name, FoodSource source, NutrientBasis basis, Nutrients nutrients, DateTime createdAt, DateTime updatedAt, String? brand, String? barcode, double? servingSizeMetric, ServingUnit? servingUnit, String? householdMeasure, bool energyIsManual, DateTime? lastLoggedAt, bool isFavorite
});


$NutrientsCopyWith<$Res> get nutrients;

}
/// @nodoc
class _$FoodCopyWithImpl<$Res>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._self, this._then);

  final Food _self;
  final $Res Function(Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? source = null,Object? basis = null,Object? nutrients = null,Object? createdAt = null,Object? updatedAt = null,Object? brand = freezed,Object? barcode = freezed,Object? servingSizeMetric = freezed,Object? servingUnit = freezed,Object? householdMeasure = freezed,Object? energyIsManual = null,Object? lastLoggedAt = freezed,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as FoodSource,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as NutrientBasis,nutrients: null == nutrients ? _self.nutrients : nutrients // ignore: cast_nullable_to_non_nullable
as Nutrients,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,servingSizeMetric: freezed == servingSizeMetric ? _self.servingSizeMetric : servingSizeMetric // ignore: cast_nullable_to_non_nullable
as double?,servingUnit: freezed == servingUnit ? _self.servingUnit : servingUnit // ignore: cast_nullable_to_non_nullable
as ServingUnit?,householdMeasure: freezed == householdMeasure ? _self.householdMeasure : householdMeasure // ignore: cast_nullable_to_non_nullable
as String?,energyIsManual: null == energyIsManual ? _self.energyIsManual : energyIsManual // ignore: cast_nullable_to_non_nullable
as bool,lastLoggedAt: freezed == lastLoggedAt ? _self.lastLoggedAt : lastLoggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutrientsCopyWith<$Res> get nutrients {
  
  return $NutrientsCopyWith<$Res>(_self.nutrients, (value) {
    return _then(_self.copyWith(nutrients: value));
  });
}
}


/// Adds pattern-matching-related methods to [Food].
extension FoodPatterns on Food {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Food value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Food value)  $default,){
final _that = this;
switch (_that) {
case _Food():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Food value)?  $default,){
final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  FoodSource source,  NutrientBasis basis,  Nutrients nutrients,  DateTime createdAt,  DateTime updatedAt,  String? brand,  String? barcode,  double? servingSizeMetric,  ServingUnit? servingUnit,  String? householdMeasure,  bool energyIsManual,  DateTime? lastLoggedAt,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.source,_that.basis,_that.nutrients,_that.createdAt,_that.updatedAt,_that.brand,_that.barcode,_that.servingSizeMetric,_that.servingUnit,_that.householdMeasure,_that.energyIsManual,_that.lastLoggedAt,_that.isFavorite);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  FoodSource source,  NutrientBasis basis,  Nutrients nutrients,  DateTime createdAt,  DateTime updatedAt,  String? brand,  String? barcode,  double? servingSizeMetric,  ServingUnit? servingUnit,  String? householdMeasure,  bool energyIsManual,  DateTime? lastLoggedAt,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _Food():
return $default(_that.id,_that.name,_that.source,_that.basis,_that.nutrients,_that.createdAt,_that.updatedAt,_that.brand,_that.barcode,_that.servingSizeMetric,_that.servingUnit,_that.householdMeasure,_that.energyIsManual,_that.lastLoggedAt,_that.isFavorite);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  FoodSource source,  NutrientBasis basis,  Nutrients nutrients,  DateTime createdAt,  DateTime updatedAt,  String? brand,  String? barcode,  double? servingSizeMetric,  ServingUnit? servingUnit,  String? householdMeasure,  bool energyIsManual,  DateTime? lastLoggedAt,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.source,_that.basis,_that.nutrients,_that.createdAt,_that.updatedAt,_that.brand,_that.barcode,_that.servingSizeMetric,_that.servingUnit,_that.householdMeasure,_that.energyIsManual,_that.lastLoggedAt,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Food extends Food {
  const _Food({required this.id, required this.name, required this.source, required this.basis, required this.nutrients, required this.createdAt, required this.updatedAt, this.brand, this.barcode, this.servingSizeMetric, this.servingUnit, this.householdMeasure, this.energyIsManual = false, this.lastLoggedAt, this.isFavorite = false}): super._();
  factory _Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

@override final  String id;
@override final  String name;
@override final  FoodSource source;
@override final  NutrientBasis basis;
@override final  Nutrients nutrients;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? brand;
@override final  String? barcode;
@override final  double? servingSizeMetric;
@override final  ServingUnit? servingUnit;
@override final  String? householdMeasure;
@override@JsonKey() final  bool energyIsManual;
@override final  DateTime? lastLoggedAt;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCopyWith<_Food> get copyWith => __$FoodCopyWithImpl<_Food>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Food&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.nutrients, nutrients) || other.nutrients == nutrients)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.servingSizeMetric, servingSizeMetric) || other.servingSizeMetric == servingSizeMetric)&&(identical(other.servingUnit, servingUnit) || other.servingUnit == servingUnit)&&(identical(other.householdMeasure, householdMeasure) || other.householdMeasure == householdMeasure)&&(identical(other.energyIsManual, energyIsManual) || other.energyIsManual == energyIsManual)&&(identical(other.lastLoggedAt, lastLoggedAt) || other.lastLoggedAt == lastLoggedAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,source,basis,nutrients,createdAt,updatedAt,brand,barcode,servingSizeMetric,servingUnit,householdMeasure,energyIsManual,lastLoggedAt,isFavorite);

@override
String toString() {
  return 'Food(id: $id, name: $name, source: $source, basis: $basis, nutrients: $nutrients, createdAt: $createdAt, updatedAt: $updatedAt, brand: $brand, barcode: $barcode, servingSizeMetric: $servingSizeMetric, servingUnit: $servingUnit, householdMeasure: $householdMeasure, energyIsManual: $energyIsManual, lastLoggedAt: $lastLoggedAt, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$FoodCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$FoodCopyWith(_Food value, $Res Function(_Food) _then) = __$FoodCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, FoodSource source, NutrientBasis basis, Nutrients nutrients, DateTime createdAt, DateTime updatedAt, String? brand, String? barcode, double? servingSizeMetric, ServingUnit? servingUnit, String? householdMeasure, bool energyIsManual, DateTime? lastLoggedAt, bool isFavorite
});


@override $NutrientsCopyWith<$Res> get nutrients;

}
/// @nodoc
class __$FoodCopyWithImpl<$Res>
    implements _$FoodCopyWith<$Res> {
  __$FoodCopyWithImpl(this._self, this._then);

  final _Food _self;
  final $Res Function(_Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? source = null,Object? basis = null,Object? nutrients = null,Object? createdAt = null,Object? updatedAt = null,Object? brand = freezed,Object? barcode = freezed,Object? servingSizeMetric = freezed,Object? servingUnit = freezed,Object? householdMeasure = freezed,Object? energyIsManual = null,Object? lastLoggedAt = freezed,Object? isFavorite = null,}) {
  return _then(_Food(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as FoodSource,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as NutrientBasis,nutrients: null == nutrients ? _self.nutrients : nutrients // ignore: cast_nullable_to_non_nullable
as Nutrients,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,servingSizeMetric: freezed == servingSizeMetric ? _self.servingSizeMetric : servingSizeMetric // ignore: cast_nullable_to_non_nullable
as double?,servingUnit: freezed == servingUnit ? _self.servingUnit : servingUnit // ignore: cast_nullable_to_non_nullable
as ServingUnit?,householdMeasure: freezed == householdMeasure ? _self.householdMeasure : householdMeasure // ignore: cast_nullable_to_non_nullable
as String?,energyIsManual: null == energyIsManual ? _self.energyIsManual : energyIsManual // ignore: cast_nullable_to_non_nullable
as bool,lastLoggedAt: freezed == lastLoggedAt ? _self.lastLoggedAt : lastLoggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutrientsCopyWith<$Res> get nutrients {
  
  return $NutrientsCopyWith<$Res>(_self.nutrients, (value) {
    return _then(_self.copyWith(nutrients: value));
  });
}
}

// dart format on
