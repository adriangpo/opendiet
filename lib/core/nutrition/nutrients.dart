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

  // ---------------------------------------------------------------------------
  // Micronutrient map keys
  // ---------------------------------------------------------------------------

  /// Calcium in milligrams.
  static const String calciumKey = 'calcium_mg';

  /// Iron in milligrams.
  static const String ironKey = 'iron_mg';

  /// Potassium in milligrams.
  static const String potassiumKey = 'potassium_mg';

  /// Magnesium in milligrams.
  static const String magnesiumKey = 'magnesium_mg';

  /// Zinc in milligrams.
  static const String zincKey = 'zinc_mg';

  /// Vitamin A in micrograms.
  static const String vitaminAKey = 'vitamin_a_mcg';

  /// Vitamin C in milligrams.
  static const String vitaminCKey = 'vitamin_c_mg';

  /// Vitamin D in micrograms.
  static const String vitaminDKey = 'vitamin_d_mcg';

  /// Vitamin B12 in micrograms.
  static const String vitaminB12Key = 'vitamin_b12_mcg';

  // ---------------------------------------------------------------------------
  // Sugar sub-type keys (in grams, parent: totalSugars)
  // ---------------------------------------------------------------------------

  static const String starchKey = 'starch_g';
  static const String glucoseKey = 'glucose_g';
  static const String fructoseKey = 'fructose_g';
  static const String sucroseKey = 'sucrose_g';
  static const String lactoseKey = 'lactose_g';
  static const String maltoseKey = 'maltose_g';
  static const String polyolsKey = 'polyols_g';

  /// Keys whose sum the tolerance check compares against [totalSugars].
  static const Set<String> sugarSubTypeKeys = {
    starchKey,
    glucoseKey,
    fructoseKey,
    sucroseKey,
    lactoseKey,
    maltoseKey,
    polyolsKey,
  };

  // ---------------------------------------------------------------------------
  // Fat sub-type keys (in grams, parent: totalFat)
  // ---------------------------------------------------------------------------

  static const String monounsaturatedKey = 'monounsaturated_g';
  static const String polyunsaturatedKey = 'polyunsaturated_g';
  static const String omega3Key = 'omega3_g';
  static const String omega6Key = 'omega6_g';
  static const String cholesterolKey = 'cholesterol_mg';

  /// Keys whose sum the tolerance check compares against [totalFat].
  static const Set<String> fatSubTypeKeys = {
    monounsaturatedKey,
    polyunsaturatedKey,
    omega3Key,
    omega6Key,
  };

  // ---------------------------------------------------------------------------

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

  /// The value for a micronutrient key, or null.
  double? micronutrient(String key) => micronutrients[key];

  /// Sum of the sub-type values whose keys are in [subTypeKeys].
  double subTypeSum(Set<String> subTypeKeys) {
    double sum = 0;
    for (final key in subTypeKeys) {
      final v = micronutrients[key];
      if (v != null) sum += v;
    }
    return sum;
  }

  /// Whether the sum of [subTypeKeys] exceeds [parentValue] by more than
  /// [tolerance] (fraction, default 5 %).
  bool hasSubTypeMismatch(
    double? parentValue,
    Set<String> subTypeKeys, {
    double tolerance = 0.05,
  }) {
    if (parentValue == null) return false;
    final sum = subTypeSum(subTypeKeys);
    if (sum == 0) return false;
    return sum > parentValue * (1 + tolerance);
  }

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
