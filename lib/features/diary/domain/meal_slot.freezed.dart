// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealSlot {

 String get id; String get name; int get position;
/// Create a copy of MealSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealSlotCopyWith<MealSlot> get copyWith => _$MealSlotCopyWithImpl<MealSlot>(this as MealSlot, _$identity);

  /// Serializes this MealSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position);

@override
String toString() {
  return 'MealSlot(id: $id, name: $name, position: $position)';
}


}

/// @nodoc
abstract mixin class $MealSlotCopyWith<$Res>  {
  factory $MealSlotCopyWith(MealSlot value, $Res Function(MealSlot) _then) = _$MealSlotCopyWithImpl;
@useResult
$Res call({
 String id, String name, int position
});




}
/// @nodoc
class _$MealSlotCopyWithImpl<$Res>
    implements $MealSlotCopyWith<$Res> {
  _$MealSlotCopyWithImpl(this._self, this._then);

  final MealSlot _self;
  final $Res Function(MealSlot) _then;

/// Create a copy of MealSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? position = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MealSlot].
extension MealSlotPatterns on MealSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealSlot value)  $default,){
final _that = this;
switch (_that) {
case _MealSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealSlot value)?  $default,){
final _that = this;
switch (_that) {
case _MealSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealSlot() when $default != null:
return $default(_that.id,_that.name,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int position)  $default,) {final _that = this;
switch (_that) {
case _MealSlot():
return $default(_that.id,_that.name,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int position)?  $default,) {final _that = this;
switch (_that) {
case _MealSlot() when $default != null:
return $default(_that.id,_that.name,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealSlot implements MealSlot {
  const _MealSlot({required this.id, required this.name, required this.position});
  factory _MealSlot.fromJson(Map<String, dynamic> json) => _$MealSlotFromJson(json);

@override final  String id;
@override final  String name;
@override final  int position;

/// Create a copy of MealSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealSlotCopyWith<_MealSlot> get copyWith => __$MealSlotCopyWithImpl<_MealSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealSlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position);

@override
String toString() {
  return 'MealSlot(id: $id, name: $name, position: $position)';
}


}

/// @nodoc
abstract mixin class _$MealSlotCopyWith<$Res> implements $MealSlotCopyWith<$Res> {
  factory _$MealSlotCopyWith(_MealSlot value, $Res Function(_MealSlot) _then) = __$MealSlotCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int position
});




}
/// @nodoc
class __$MealSlotCopyWithImpl<$Res>
    implements _$MealSlotCopyWith<$Res> {
  __$MealSlotCopyWithImpl(this._self, this._then);

  final _MealSlot _self;
  final $Res Function(_MealSlot) _then;

/// Create a copy of MealSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? position = null,}) {
  return _then(_MealSlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
