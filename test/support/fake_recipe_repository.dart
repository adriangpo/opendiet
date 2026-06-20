import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/domain/recipe_repository.dart';

/// An in-memory [RecipeRepository] for widget tests that records what was saved.
class FakeRecipeRepository implements RecipeRepository {
  /// Every recipe passed to [saveRecipe], in order.
  final List<Recipe> _recipes = [];

  /// The most recently saved recipe, or null when nothing was saved.
  Recipe? get lastSaved => _recipes.isEmpty ? null : _recipes.last;

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index >= 0) {
      _recipes[index] = recipe;
    } else {
      _recipes.add(recipe);
    }
  }

  @override
  Future<Recipe?> findRecipe(String id) async {
    for (final recipe in _recipes.reversed) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  @override
  Future<List<Recipe>> allRecipes() async => List.of(_recipes);

  @override
  Future<void> deleteRecipe(String id) async {
    _recipes.removeWhere((r) => r.id == id);
  }
}
