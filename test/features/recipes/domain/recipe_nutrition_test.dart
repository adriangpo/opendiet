import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/domain/recipe_nutrition.dart';

Food _food(String id, Nutrients nutrients) => Food(
  id: id,
  name: id,
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: nutrients,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

Recipe _recipe({
  required double yieldServings,
  required List<RecipeIngredient> ingredients,
}) => Recipe(
  id: 'r',
  name: 'Test Recipe',
  yieldServings: yieldServings,
  ingredients: ingredients,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  final foods = <String, Food>{
    'flour': _food('flour', const Nutrients(energyKcal: 364, protein: 10)),
    'sugar': _food('sugar', const Nutrients(energyKcal: 400)),
  };

  group('RecipeNutrition.total', () {
    test('sums each ingredient contribution across nutrients (FR-016)', () {
      final recipe = _recipe(
        yieldServings: 4,
        ingredients: [
          RecipeIngredient(foodId: 'flour', quantity: Quantity.grams(200)),
          RecipeIngredient(foodId: 'sugar', quantity: Quantity.grams(100)),
        ],
      );

      final total = RecipeNutrition.total(recipe, foods);

      // flour: 364*2 = 728 ; sugar: 400*1 = 400.
      expect(total.energyKcal, closeTo(1128, 1e-9));
      // protein only present on flour: 10*2 = 20, sugar contributes nothing.
      expect(total.protein, closeTo(20, 1e-9));
    });

    test('an empty recipe totals to all-absent', () {
      final recipe = _recipe(yieldServings: 1, ingredients: const []);

      expect(RecipeNutrition.total(recipe, foods), Nutrients.empty);
    });

    test('a missing ingredient food throws (FR-023)', () {
      final recipe = _recipe(
        yieldServings: 1,
        ingredients: [
          RecipeIngredient(foodId: 'unknown', quantity: Quantity.grams(10)),
        ],
      );

      expect(() => RecipeNutrition.total(recipe, foods), throwsArgumentError);
    });
  });

  group('RecipeNutrition.perServing', () {
    test('is the total divided by the yield (FR-016)', () {
      final recipe = _recipe(
        yieldServings: 4,
        ingredients: [
          RecipeIngredient(foodId: 'sugar', quantity: Quantity.grams(100)),
        ],
      );

      // total 400 kcal / 4 servings.
      expect(
        RecipeNutrition.perServing(recipe, foods).energyKcal,
        closeTo(100, 1e-9),
      );
    });

    test('handles a fractional yield', () {
      final recipe = _recipe(
        yieldServings: 2.5,
        ingredients: [
          RecipeIngredient(foodId: 'sugar', quantity: Quantity.grams(100)),
        ],
      );

      expect(
        RecipeNutrition.perServing(recipe, foods).energyKcal,
        closeTo(160, 1e-9),
      );
    });

    test('rejects a non-positive yield (FR-023)', () {
      final recipe = _recipe(
        yieldServings: 0,
        ingredients: [
          RecipeIngredient(foodId: 'sugar', quantity: Quantity.grams(100)),
        ],
      );

      expect(
        () => RecipeNutrition.perServing(recipe, foods),
        throwsArgumentError,
      );
    });
  });

  group('RecipeNutrition.forServings (FR-017)', () {
    test('is per-serving nutrition times the servings consumed', () {
      final recipe = _recipe(
        yieldServings: 4,
        ingredients: [
          RecipeIngredient(foodId: 'sugar', quantity: Quantity.grams(100)),
        ],
      );

      // per serving 100 kcal, eat 1.5 servings -> 150 kcal.
      expect(
        RecipeNutrition.forServings(recipe, foods, 1.5).energyKcal,
        closeTo(150, 1e-9),
      );
    });
  });
}
