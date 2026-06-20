import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/foods/domain/food.dart';

/// Computes the nutrition of an amount of a [Food] (FR-003).
///
/// All three [FoodSource]s feed this single calculation; conversion between a
/// per-100 and a per-serving view requires the food's serving size, and a
/// request that cannot be satisfied throws rather than guessing (FR-023).
abstract final class FoodNutrition {
  /// Nutrients for [quantity] of [food].
  static Nutrients forQuantity(Food food, Quantity quantity) =>
      switch (quantity.measure) {
        QuantityMeasure.servings => perServing(food).scale(quantity.amount),
        QuantityMeasure.grams || QuantityMeasure.milliliters => per100(
          food,
        ).scale(quantity.amount / 100),
      };

  /// The food's nutrition per 100 g/ml.
  static Nutrients per100(Food food) => switch (food.basis) {
    NutrientBasis.per100g || NutrientBasis.per100ml => food.nutrients,
    NutrientBasis.perServing => food.nutrients.scale(
      100 / _requireServingSize(food),
    ),
  };

  /// The food's nutrition for one serving.
  static Nutrients perServing(Food food) => switch (food.basis) {
    NutrientBasis.perServing => food.nutrients,
    NutrientBasis.per100g || NutrientBasis.per100ml => food.nutrients.scale(
      _requireServingSize(food) / 100,
    ),
  };

  static double _requireServingSize(Food food) {
    final size = food.servingSizeMetric;
    if (size == null || size <= 0) {
      throw ArgumentError.value(
        size,
        'servingSizeMetric',
        'food "${food.name}" needs a positive serving size to convert between '
            'per-serving and per-100 nutrition',
      );
    }
    return size;
  }
}
