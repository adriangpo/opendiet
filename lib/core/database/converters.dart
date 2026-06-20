import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';

/// Stores a [Nutrients] profile as a JSON document in a text column.
///
/// Nutrient amounts are computed in Dart, so a JSON blob is enough; the ten
/// mandatory nutrients remain first-class on the domain model (FR-025).
class NutrientsConverter extends TypeConverter<Nutrients, String> {
  /// Creates the converter.
  const NutrientsConverter();

  @override
  Nutrients fromSql(String fromDb) =>
      Nutrients.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);

  @override
  String toSql(Nutrients value) => jsonEncode(value.toJson());
}

/// Stores a [DateTime] as the absolute millisecond epoch and reads it back in
/// UTC, so persisted instants round-trip exactly regardless of time zone.
class DateTimeMillisConverter extends TypeConverter<DateTime, int> {
  /// Creates the converter.
  const DateTimeMillisConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMillisecondsSinceEpoch(fromDb, isUtc: true);

  @override
  int toSql(DateTime value) => value.millisecondsSinceEpoch;
}
