// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrients.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Nutrients {

 double? get energyKcal; double? get carbohydrates; double? get totalSugars; double? get addedSugars; double? get protein; double? get totalFat; double? get saturatedFat; double? get transFat; double? get dietaryFiber; double? get sodiumMilligrams; Map<String, double> get micronutrients;
/// Create a copy of Nutrients
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NutrientsCopyWith<Nutrients> get copyWith => _$NutrientsCopyWithImpl<Nutrients>(this as Nutrients, _$identity);

  /// Serializes this Nutrients to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nutrients&&(identical(other.energyKcal, energyKcal) || other.energyKcal == energyKcal)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.totalSugars, totalSugars) || other.totalSugars == totalSugars)&&(identical(other.addedSugars, addedSugars) || other.addedSugars == addedSugars)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.totalFat, totalFat) || other.totalFat == totalFat)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.transFat, transFat) || other.transFat == transFat)&&(identical(other.dietaryFiber, dietaryFiber) || other.dietaryFiber == dietaryFiber)&&(identical(other.sodiumMilligrams, sodiumMilligrams) || other.sodiumMilligrams == sodiumMilligrams)&&const DeepCollectionEquality().equals(other.micronutrients, micronutrients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,energyKcal,carbohydrates,totalSugars,addedSugars,protein,totalFat,saturatedFat,transFat,dietaryFiber,sodiumMilligrams,const DeepCollectionEquality().hash(micronutrients));

@override
String toString() {
  return 'Nutrients(energyKcal: $energyKcal, carbohydrates: $carbohydrates, totalSugars: $totalSugars, addedSugars: $addedSugars, protein: $protein, totalFat: $totalFat, saturatedFat: $saturatedFat, transFat: $transFat, dietaryFiber: $dietaryFiber, sodiumMilligrams: $sodiumMilligrams, micronutrients: $micronutrients)';
}


}

/// @nodoc
abstract mixin class $NutrientsCopyWith<$Res>  {
  factory $NutrientsCopyWith(Nutrients value, $Res Function(Nutrients) _then) = _$NutrientsCopyWithImpl;
@useResult
$Res call({
 double? energyKcal, double? carbohydrates, double? totalSugars, double? addedSugars, double? protein, double? totalFat, double? saturatedFat, double? transFat, double? dietaryFiber, double? sodiumMilligrams, Map<String, double> micronutrients
});




}
/// @nodoc
class _$NutrientsCopyWithImpl<$Res>
    implements $NutrientsCopyWith<$Res> {
  _$NutrientsCopyWithImpl(this._self, this._then);

  final Nutrients _self;
  final $Res Function(Nutrients) _then;

/// Create a copy of Nutrients
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? energyKcal = freezed,Object? carbohydrates = freezed,Object? totalSugars = freezed,Object? addedSugars = freezed,Object? protein = freezed,Object? totalFat = freezed,Object? saturatedFat = freezed,Object? transFat = freezed,Object? dietaryFiber = freezed,Object? sodiumMilligrams = freezed,Object? micronutrients = null,}) {
  return _then(_self.copyWith(
energyKcal: freezed == energyKcal ? _self.energyKcal : energyKcal // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,totalSugars: freezed == totalSugars ? _self.totalSugars : totalSugars // ignore: cast_nullable_to_non_nullable
as double?,addedSugars: freezed == addedSugars ? _self.addedSugars : addedSugars // ignore: cast_nullable_to_non_nullable
as double?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,totalFat: freezed == totalFat ? _self.totalFat : totalFat // ignore: cast_nullable_to_non_nullable
as double?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as double?,transFat: freezed == transFat ? _self.transFat : transFat // ignore: cast_nullable_to_non_nullable
as double?,dietaryFiber: freezed == dietaryFiber ? _self.dietaryFiber : dietaryFiber // ignore: cast_nullable_to_non_nullable
as double?,sodiumMilligrams: freezed == sodiumMilligrams ? _self.sodiumMilligrams : sodiumMilligrams // ignore: cast_nullable_to_non_nullable
as double?,micronutrients: null == micronutrients ? _self.micronutrients : micronutrients // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [Nutrients].
extension NutrientsPatterns on Nutrients {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Nutrients value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Nutrients() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Nutrients value)  $default,){
final _that = this;
switch (_that) {
case _Nutrients():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Nutrients value)?  $default,){
final _that = this;
switch (_that) {
case _Nutrients() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? energyKcal,  double? carbohydrates,  double? totalSugars,  double? addedSugars,  double? protein,  double? totalFat,  double? saturatedFat,  double? transFat,  double? dietaryFiber,  double? sodiumMilligrams,  Map<String, double> micronutrients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Nutrients() when $default != null:
return $default(_that.energyKcal,_that.carbohydrates,_that.totalSugars,_that.addedSugars,_that.protein,_that.totalFat,_that.saturatedFat,_that.transFat,_that.dietaryFiber,_that.sodiumMilligrams,_that.micronutrients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? energyKcal,  double? carbohydrates,  double? totalSugars,  double? addedSugars,  double? protein,  double? totalFat,  double? saturatedFat,  double? transFat,  double? dietaryFiber,  double? sodiumMilligrams,  Map<String, double> micronutrients)  $default,) {final _that = this;
switch (_that) {
case _Nutrients():
return $default(_that.energyKcal,_that.carbohydrates,_that.totalSugars,_that.addedSugars,_that.protein,_that.totalFat,_that.saturatedFat,_that.transFat,_that.dietaryFiber,_that.sodiumMilligrams,_that.micronutrients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? energyKcal,  double? carbohydrates,  double? totalSugars,  double? addedSugars,  double? protein,  double? totalFat,  double? saturatedFat,  double? transFat,  double? dietaryFiber,  double? sodiumMilligrams,  Map<String, double> micronutrients)?  $default,) {final _that = this;
switch (_that) {
case _Nutrients() when $default != null:
return $default(_that.energyKcal,_that.carbohydrates,_that.totalSugars,_that.addedSugars,_that.protein,_that.totalFat,_that.saturatedFat,_that.transFat,_that.dietaryFiber,_that.sodiumMilligrams,_that.micronutrients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Nutrients extends Nutrients {
  const _Nutrients({this.energyKcal, this.carbohydrates, this.totalSugars, this.addedSugars, this.protein, this.totalFat, this.saturatedFat, this.transFat, this.dietaryFiber, this.sodiumMilligrams, final  Map<String, double> micronutrients = const <String, double>{}}): _micronutrients = micronutrients,super._();
  factory _Nutrients.fromJson(Map<String, dynamic> json) => _$NutrientsFromJson(json);

@override final  double? energyKcal;
@override final  double? carbohydrates;
@override final  double? totalSugars;
@override final  double? addedSugars;
@override final  double? protein;
@override final  double? totalFat;
@override final  double? saturatedFat;
@override final  double? transFat;
@override final  double? dietaryFiber;
@override final  double? sodiumMilligrams;
 final  Map<String, double> _micronutrients;
@override@JsonKey() Map<String, double> get micronutrients {
  if (_micronutrients is EqualUnmodifiableMapView) return _micronutrients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_micronutrients);
}


/// Create a copy of Nutrients
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NutrientsCopyWith<_Nutrients> get copyWith => __$NutrientsCopyWithImpl<_Nutrients>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NutrientsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Nutrients&&(identical(other.energyKcal, energyKcal) || other.energyKcal == energyKcal)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.totalSugars, totalSugars) || other.totalSugars == totalSugars)&&(identical(other.addedSugars, addedSugars) || other.addedSugars == addedSugars)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.totalFat, totalFat) || other.totalFat == totalFat)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.transFat, transFat) || other.transFat == transFat)&&(identical(other.dietaryFiber, dietaryFiber) || other.dietaryFiber == dietaryFiber)&&(identical(other.sodiumMilligrams, sodiumMilligrams) || other.sodiumMilligrams == sodiumMilligrams)&&const DeepCollectionEquality().equals(other._micronutrients, _micronutrients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,energyKcal,carbohydrates,totalSugars,addedSugars,protein,totalFat,saturatedFat,transFat,dietaryFiber,sodiumMilligrams,const DeepCollectionEquality().hash(_micronutrients));

@override
String toString() {
  return 'Nutrients(energyKcal: $energyKcal, carbohydrates: $carbohydrates, totalSugars: $totalSugars, addedSugars: $addedSugars, protein: $protein, totalFat: $totalFat, saturatedFat: $saturatedFat, transFat: $transFat, dietaryFiber: $dietaryFiber, sodiumMilligrams: $sodiumMilligrams, micronutrients: $micronutrients)';
}


}

/// @nodoc
abstract mixin class _$NutrientsCopyWith<$Res> implements $NutrientsCopyWith<$Res> {
  factory _$NutrientsCopyWith(_Nutrients value, $Res Function(_Nutrients) _then) = __$NutrientsCopyWithImpl;
@override @useResult
$Res call({
 double? energyKcal, double? carbohydrates, double? totalSugars, double? addedSugars, double? protein, double? totalFat, double? saturatedFat, double? transFat, double? dietaryFiber, double? sodiumMilligrams, Map<String, double> micronutrients
});




}
/// @nodoc
class __$NutrientsCopyWithImpl<$Res>
    implements _$NutrientsCopyWith<$Res> {
  __$NutrientsCopyWithImpl(this._self, this._then);

  final _Nutrients _self;
  final $Res Function(_Nutrients) _then;

/// Create a copy of Nutrients
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? energyKcal = freezed,Object? carbohydrates = freezed,Object? totalSugars = freezed,Object? addedSugars = freezed,Object? protein = freezed,Object? totalFat = freezed,Object? saturatedFat = freezed,Object? transFat = freezed,Object? dietaryFiber = freezed,Object? sodiumMilligrams = freezed,Object? micronutrients = null,}) {
  return _then(_Nutrients(
energyKcal: freezed == energyKcal ? _self.energyKcal : energyKcal // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,totalSugars: freezed == totalSugars ? _self.totalSugars : totalSugars // ignore: cast_nullable_to_non_nullable
as double?,addedSugars: freezed == addedSugars ? _self.addedSugars : addedSugars // ignore: cast_nullable_to_non_nullable
as double?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,totalFat: freezed == totalFat ? _self.totalFat : totalFat // ignore: cast_nullable_to_non_nullable
as double?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as double?,transFat: freezed == transFat ? _self.transFat : transFat // ignore: cast_nullable_to_non_nullable
as double?,dietaryFiber: freezed == dietaryFiber ? _self.dietaryFiber : dietaryFiber // ignore: cast_nullable_to_non_nullable
as double?,sodiumMilligrams: freezed == sodiumMilligrams ? _self.sodiumMilligrams : sodiumMilligrams // ignore: cast_nullable_to_non_nullable
as double?,micronutrients: null == micronutrients ? _self._micronutrients : micronutrients // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
