import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opendiet/core/nutrition/quantity.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

/// One ingredient line of a recipe: a reference to a food and how much of it.
@freezed
abstract class RecipeIngredient with _$RecipeIngredient {
  /// Creates an ingredient line.
  const factory RecipeIngredient({
    required String foodId,
    required Quantity quantity,
  }) = _RecipeIngredient;

  /// Builds an ingredient from its JSON form.
  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
}

/// A recipe: foods with quantities and a yield in servings (FR-015).
///
/// Nutrition is computed from the ingredients and yield by the recipe nutrition
/// use case (FR-016), not stored here.
@freezed
abstract class Recipe with _$Recipe {
  /// Creates a recipe.
  const factory Recipe({
    required String id,
    required String name,
    required double yieldServings,
    required List<RecipeIngredient> ingredients,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Recipe;

  /// Builds a recipe from its JSON form.
  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
