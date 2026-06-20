import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';

Recipe _sampleRecipe() => Recipe(
  id: 'r1',
  name: 'Pancakes',
  yieldServings: 4,
  ingredients: [
    RecipeIngredient(foodId: 'flour', quantity: Quantity.grams(200)),
    RecipeIngredient(foodId: 'egg', quantity: Quantity.servings(2)),
  ],
  createdAt: DateTime.utc(2026, 6, 19),
  updatedAt: DateTime.utc(2026, 6, 19),
);

void main() {
  group('Recipe', () {
    test('round-trips through json with its ingredient list', () {
      final recipe = _sampleRecipe();

      final restored = Recipe.fromJson(recipe.toJson());

      expect(restored, recipe);
      expect(restored.ingredients, hasLength(2));
      expect(restored.ingredients.first.quantity, Quantity.grams(200));
    });

    test('preserves an empty ingredient list', () {
      final recipe = _sampleRecipe().copyWith(ingredients: const []);

      expect(Recipe.fromJson(recipe.toJson()).ingredients, isEmpty);
    });
  });
}
