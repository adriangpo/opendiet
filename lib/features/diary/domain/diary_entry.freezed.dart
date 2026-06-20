// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryEntry {

 String get id; DateTime get day; String get mealSlotId; DiaryReferenceKind get referenceKind; String get label; String? get referenceId; Quantity get quantity; Nutrients get nutrients; DateTime get loggedAt;
/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryEntryCopyWith<DiaryEntry> get copyWith => _$DiaryEntryCopyWithImpl<DiaryEntry>(this as DiaryEntry, _$identity);

  /// Serializes this DiaryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.day, day) || other.day == day)&&(identical(other.mealSlotId, mealSlotId) || other.mealSlotId == mealSlotId)&&(identical(other.referenceKind, referenceKind) || other.referenceKind == referenceKind)&&(identical(other.label, label) || other.label == label)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.nutrients, nutrients) || other.nutrients == nutrients)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,day,mealSlotId,referenceKind,label,referenceId,quantity,nutrients,loggedAt);

@override
String toString() {
  return 'DiaryEntry(id: $id, day: $day, mealSlotId: $mealSlotId, referenceKind: $referenceKind, label: $label, referenceId: $referenceId, quantity: $quantity, nutrients: $nutrients, loggedAt: $loggedAt)';
}


}

/// @nodoc
abstract mixin class $DiaryEntryCopyWith<$Res>  {
  factory $DiaryEntryCopyWith(DiaryEntry value, $Res Function(DiaryEntry) _then) = _$DiaryEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime day, String mealSlotId, DiaryReferenceKind referenceKind, String label, String? referenceId, Quantity quantity, Nutrients nutrients, DateTime loggedAt
});


$QuantityCopyWith<$Res> get quantity;$NutrientsCopyWith<$Res> get nutrients;

}
/// @nodoc
class _$DiaryEntryCopyWithImpl<$Res>
    implements $DiaryEntryCopyWith<$Res> {
  _$DiaryEntryCopyWithImpl(this._self, this._then);

  final DiaryEntry _self;
  final $Res Function(DiaryEntry) _then;

/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? day = null,Object? mealSlotId = null,Object? referenceKind = null,Object? label = null,Object? referenceId = freezed,Object? quantity = null,Object? nutrients = null,Object? loggedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,mealSlotId: null == mealSlotId ? _self.mealSlotId : mealSlotId // ignore: cast_nullable_to_non_nullable
as String,referenceKind: null == referenceKind ? _self.referenceKind : referenceKind // ignore: cast_nullable_to_non_nullable
as DiaryReferenceKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,nutrients: null == nutrients ? _self.nutrients : nutrients // ignore: cast_nullable_to_non_nullable
as Nutrients,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutrientsCopyWith<$Res> get nutrients {
  
  return $NutrientsCopyWith<$Res>(_self.nutrients, (value) {
    return _then(_self.copyWith(nutrients: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiaryEntry].
extension DiaryEntryPatterns on DiaryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryEntry value)  $default,){
final _that = this;
switch (_that) {
case _DiaryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime day,  String mealSlotId,  DiaryReferenceKind referenceKind,  String label,  String? referenceId,  Quantity quantity,  Nutrients nutrients,  DateTime loggedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
return $default(_that.id,_that.day,_that.mealSlotId,_that.referenceKind,_that.label,_that.referenceId,_that.quantity,_that.nutrients,_that.loggedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime day,  String mealSlotId,  DiaryReferenceKind referenceKind,  String label,  String? referenceId,  Quantity quantity,  Nutrients nutrients,  DateTime loggedAt)  $default,) {final _that = this;
switch (_that) {
case _DiaryEntry():
return $default(_that.id,_that.day,_that.mealSlotId,_that.referenceKind,_that.label,_that.referenceId,_that.quantity,_that.nutrients,_that.loggedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime day,  String mealSlotId,  DiaryReferenceKind referenceKind,  String label,  String? referenceId,  Quantity quantity,  Nutrients nutrients,  DateTime loggedAt)?  $default,) {final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
return $default(_that.id,_that.day,_that.mealSlotId,_that.referenceKind,_that.label,_that.referenceId,_that.quantity,_that.nutrients,_that.loggedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryEntry implements DiaryEntry {
  const _DiaryEntry({required this.id, required this.day, required this.mealSlotId, required this.referenceKind, required this.label, this.referenceId, required this.quantity, required this.nutrients, required this.loggedAt});
  factory _DiaryEntry.fromJson(Map<String, dynamic> json) => _$DiaryEntryFromJson(json);

@override final  String id;
@override final  DateTime day;
@override final  String mealSlotId;
@override final  DiaryReferenceKind referenceKind;
@override final  String label;
@override final  String? referenceId;
@override final  Quantity quantity;
@override final  Nutrients nutrients;
@override final  DateTime loggedAt;

/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryEntryCopyWith<_DiaryEntry> get copyWith => __$DiaryEntryCopyWithImpl<_DiaryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.day, day) || other.day == day)&&(identical(other.mealSlotId, mealSlotId) || other.mealSlotId == mealSlotId)&&(identical(other.referenceKind, referenceKind) || other.referenceKind == referenceKind)&&(identical(other.label, label) || other.label == label)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.nutrients, nutrients) || other.nutrients == nutrients)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,day,mealSlotId,referenceKind,label,referenceId,quantity,nutrients,loggedAt);

@override
String toString() {
  return 'DiaryEntry(id: $id, day: $day, mealSlotId: $mealSlotId, referenceKind: $referenceKind, label: $label, referenceId: $referenceId, quantity: $quantity, nutrients: $nutrients, loggedAt: $loggedAt)';
}


}

/// @nodoc
abstract mixin class _$DiaryEntryCopyWith<$Res> implements $DiaryEntryCopyWith<$Res> {
  factory _$DiaryEntryCopyWith(_DiaryEntry value, $Res Function(_DiaryEntry) _then) = __$DiaryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime day, String mealSlotId, DiaryReferenceKind referenceKind, String label, String? referenceId, Quantity quantity, Nutrients nutrients, DateTime loggedAt
});


@override $QuantityCopyWith<$Res> get quantity;@override $NutrientsCopyWith<$Res> get nutrients;

}
/// @nodoc
class __$DiaryEntryCopyWithImpl<$Res>
    implements _$DiaryEntryCopyWith<$Res> {
  __$DiaryEntryCopyWithImpl(this._self, this._then);

  final _DiaryEntry _self;
  final $Res Function(_DiaryEntry) _then;

/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? day = null,Object? mealSlotId = null,Object? referenceKind = null,Object? label = null,Object? referenceId = freezed,Object? quantity = null,Object? nutrients = null,Object? loggedAt = null,}) {
  return _then(_DiaryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,mealSlotId: null == mealSlotId ? _self.mealSlotId : mealSlotId // ignore: cast_nullable_to_non_nullable
as String,referenceKind: null == referenceKind ? _self.referenceKind : referenceKind // ignore: cast_nullable_to_non_nullable
as DiaryReferenceKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,nutrients: null == nutrients ? _self.nutrients : nutrients // ignore: cast_nullable_to_non_nullable
as Nutrients,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of DiaryEntry
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
