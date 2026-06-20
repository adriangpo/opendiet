import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_nutrition.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';

/// Computes a recipe's nutrition from its ingredients and yield
/// (FR-016, FR-017).
///
/// The foods map resolves each ingredient's food id; a missing food throws
/// rather than silently dropping an ingredient (FR-023). Ingredient nutrients
/// that are absent contribute nothing without coercing the total to zero.
abstract final class RecipeNutrition {
  /// The recipe's total nutrition (sum of every ingredient's contribution).
  static Nutrients total(Recipe recipe, Map<String, Food> foods) =>
      Nutrients.sum(
        recipe.ingredients.map((ingredient) {
          final food = foods[ingredient.foodId];
          if (food == null) {
            throw ArgumentError.value(
              ingredient.foodId,
              'foodId',
              'recipe "${recipe.name}" references a food that was not provided',
            );
          }
          return FoodNutrition.forQuantity(food, ingredient.quantity);
        }),
      );

  /// The recipe's per-serving nutrition (total divided by the yield).
  static Nutrients perServing(Recipe recipe, Map<String, Food> foods) {
    final servings = recipe.yieldServings;
    if (!servings.isFinite || servings <= 0) {
      throw ArgumentError.value(
        servings,
        'yieldServings',
        'recipe "${recipe.name}" needs a positive yield',
      );
    }
    return total(recipe, foods).scale(1 / servings);
  }

  /// Nutrition for [servings] servings of the recipe (FR-017).
  static Nutrients forServings(
    Recipe recipe,
    Map<String, Food> foods,
    double servings,
  ) => perServing(recipe, foods).scale(servings);
}
