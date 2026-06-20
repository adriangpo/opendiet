import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_nutrition.dart';

Food _food({
  required NutrientBasis basis,
  required Nutrients nutrients,
  double? servingSizeMetric,
}) => Food(
  id: 'f',
  name: 'Test Food',
  source: FoodSource.custom,
  basis: basis,
  nutrients: nutrients,
  servingSizeMetric: servingSizeMetric,
  servingUnit: ServingUnit.gram,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  group('FoodNutrition.forQuantity - per-100 basis', () {
    final food = _food(
      basis: NutrientBasis.per100g,
      nutrients: const Nutrients(energyKcal: 50, protein: 4),
      servingSizeMetric: 170,
    );

    test('scales per-100 values by a metric amount', () {
      final result = FoodNutrition.forQuantity(food, Quantity.grams(200));

      expect(result.energyKcal, closeTo(100, 1e-9));
      expect(result.protein, closeTo(8, 1e-9));
    });

    test('logging zero grams yields zero for present nutrients', () {
      final result = FoodNutrition.forQuantity(food, Quantity.grams(0));

      expect(result.energyKcal, 0);
      expect(result.protein, 0);
    });

    test('logging by servings uses the serving size', () {
      final result = FoodNutrition.forQuantity(food, Quantity.servings(1));

      // 170 g serving of a 50 kcal/100 g food -> 85 kcal.
      expect(result.energyKcal, closeTo(85, 1e-9));
    });

    test(
      'servings and the equivalent grams give the same nutrition (FR-003)',
      () {
        final byServings = FoodNutrition.forQuantity(
          food,
          Quantity.servings(1),
        );
        final byGrams = FoodNutrition.forQuantity(food, Quantity.grams(170));

        expect(byServings.energyKcal, closeTo(byGrams.energyKcal!, 1e-9));
        expect(byServings.protein, closeTo(byGrams.protein!, 1e-9));
      },
    );

    test('absent nutrients stay absent after scaling', () {
      final result = FoodNutrition.forQuantity(food, Quantity.grams(200));

      expect(result.carbohydrates, isNull);
    });
  });

  group('FoodNutrition.forQuantity - per-serving basis', () {
    final food = _food(
      basis: NutrientBasis.perServing,
      nutrients: const Nutrients(energyKcal: 100, protein: 8),
      servingSizeMetric: 50,
    );

    test('logging by servings multiplies the per-serving values', () {
      final result = FoodNutrition.forQuantity(food, Quantity.servings(2.5));

      expect(result.energyKcal, closeTo(250, 1e-9));
    });

    test('logging by grams converts through per-100', () {
      // 100 kcal per 50 g serving -> 200 kcal/100 g -> 25 g is 50 kcal.
      final result = FoodNutrition.forQuantity(food, Quantity.grams(25));

      expect(result.energyKcal, closeTo(50, 1e-9));
    });
  });

  group('FoodNutrition validation (FR-023)', () {
    test('rejects a negative quantity', () {
      final food = _food(
        basis: NutrientBasis.per100g,
        nutrients: const Nutrients(energyKcal: 50),
      );

      expect(
        () => FoodNutrition.forQuantity(food, Quantity.grams(-1)),
        throwsArgumentError,
      );
    });

    test('logging servings without a serving size throws', () {
      final food = _food(
        basis: NutrientBasis.per100g,
        nutrients: const Nutrients(energyKcal: 50),
      );

      expect(
        () => FoodNutrition.forQuantity(food, Quantity.servings(1)),
        throwsArgumentError,
      );
    });

    test(
      'logging grams of a per-serving food without a serving size throws',
      () {
        final food = _food(
          basis: NutrientBasis.perServing,
          nutrients: const Nutrients(energyKcal: 100),
        );

        expect(
          () => FoodNutrition.forQuantity(food, Quantity.grams(10)),
          throwsArgumentError,
        );
      },
    );
  });
}
