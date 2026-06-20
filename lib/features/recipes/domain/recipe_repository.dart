import 'package:opendiet/features/recipes/domain/recipe.dart';

/// Persists and retrieves recipes and their ingredients (FR-015).
///
/// Saving a recipe replaces its ingredient set atomically (FR-023).
abstract interface class RecipeRepository {
  /// Inserts or updates [recipe] and replaces its ingredients atomically.
  Future<void> saveRecipe(Recipe recipe);

  /// The recipe with [id] and its ordered ingredients, or null when absent.
  Future<Recipe?> findRecipe(String id);

  /// Removes the recipe with [id]; its ingredients cascade away.
  Future<void> deleteRecipe(String id);
}
