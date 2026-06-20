import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';

part 'nutrients.freezed.dart';
part 'nutrients.g.dart';

/// A nutrient profile: the ten ANVISA-mandatory nutrients as first-class fields
/// plus an open micronutrient set (FR-025).
///
/// Every mandatory field is nullable because an absent value means
/// "not informed", never zero (see agent_docs/brazilian_nutrition.md). Energy
/// is kilocalories, macros are grams, sodium is milligrams, and each
/// micronutrient key carries its unit suffix (e.g. "calcium_mg").
@freezed
abstract class Nutrients with _$Nutrients {
  /// Creates a nutrient profile; omitted fields are absent (not zero).
  const factory Nutrients({
    double? energyKcal,
    double? carbohydrates,
    double? totalSugars,
    double? addedSugars,
    double? protein,
    double? totalFat,
    double? saturatedFat,
    double? transFat,
    double? dietaryFiber,
    double? sodiumMilligrams,
    @Default(<String, double>{}) Map<String, double> micronutrients,
  }) = _Nutrients;

  const Nutrients._();

  /// Builds a profile from its JSON form.
  factory Nutrients.fromJson(Map<String, dynamic> json) =>
      _$NutrientsFromJson(json);

  /// An all-absent profile.
  static const Nutrients empty = Nutrients();

  /// The amount of [nutrient], or null when absent.
  double? amountOf(Nutrient nutrient) => switch (nutrient) {
    Nutrient.energy => energyKcal,
    Nutrient.carbohydrates => carbohydrates,
    Nutrient.totalSugars => totalSugars,
    Nutrient.addedSugars => addedSugars,
    Nutrient.protein => protein,
    Nutrient.totalFat => totalFat,
    Nutrient.saturatedFat => saturatedFat,
    Nutrient.transFat => transFat,
    Nutrient.dietaryFiber => dietaryFiber,
    Nutrient.sodium => sodiumMilligrams,
  };

  /// Multiplies every present value by [factor], leaving absent values absent.
  ///
  /// Used to scale a per-100 g/ml or per-serving profile to an actual amount.
  Nutrients scale(double factor) {
    if (!factor.isFinite || factor < 0) {
      throw ArgumentError.value(
        factor,
        'factor',
        'must be a finite, non-negative number',
      );
    }
    double? scaled(double? value) => value == null ? null : value * factor;
    return Nutrients(
      energyKcal: scaled(energyKcal),
      carbohydrates: scaled(carbohydrates),
      totalSugars: scaled(totalSugars),
      addedSugars: scaled(addedSugars),
      protein: scaled(protein),
      totalFat: scaled(totalFat),
      saturatedFat: scaled(saturatedFat),
      transFat: scaled(transFat),
      dietaryFiber: scaled(dietaryFiber),
      sodiumMilligrams: scaled(sodiumMilligrams),
      micronutrients: {
        for (final entry in micronutrients.entries)
          entry.key: entry.value * factor,
      },
    );
  }

  /// Adds two profiles field by field.
  ///
  /// A field absent in both operands stays absent; if it is present in either,
  /// the missing side contributes nothing. This keeps "not informed" distinct
  /// from zero while still summing partial data (FR-016, FR-004).
  Nutrients operator +(Nutrients other) {
    final keys = {...micronutrients.keys, ...other.micronutrients.keys};
    return Nutrients(
      energyKcal: _add(energyKcal, other.energyKcal),
      carbohydrates: _add(carbohydrates, other.carbohydrates),
      totalSugars: _add(totalSugars, other.totalSugars),
      addedSugars: _add(addedSugars, other.addedSugars),
      protein: _add(protein, other.protein),
      totalFat: _add(totalFat, other.totalFat),
      saturatedFat: _add(saturatedFat, other.saturatedFat),
      transFat: _add(transFat, other.transFat),
      dietaryFiber: _add(dietaryFiber, other.dietaryFiber),
      sodiumMilligrams: _add(sodiumMilligrams, other.sodiumMilligrams),
      micronutrients: {
        for (final key in keys)
          key: (micronutrients[key] ?? 0) + (other.micronutrients[key] ?? 0),
      },
    );
  }

  /// Sums every profile in [profiles]; an empty iterable yields [empty].
  static Nutrients sum(Iterable<Nutrients> profiles) =>
      profiles.fold(empty, (total, next) => total + next);

  static double? _add(double? a, double? b) {
    if (a == null && b == null) return null;
    return (a ?? 0) + (b ?? 0);
  }
}
