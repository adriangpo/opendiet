import 'package:drift/drift.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/domain/recipe_repository.dart';

/// Drift-backed [RecipeRepository].
class DriftRecipeRepository implements RecipeRepository {
  /// Creates a repository over [_database].
  DriftRecipeRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> saveRecipe(Recipe recipe) => _database.transaction(() async {
    await _database
        .into(_database.recipes)
        .insertOnConflictUpdate(
          RecipesCompanion(
            id: Value(recipe.id),
            name: Value(recipe.name),
            yieldServings: Value(recipe.yieldServings),
            createdAt: Value(recipe.createdAt),
            updatedAt: Value(recipe.updatedAt),
          ),
        );
    await (_database.delete(
      _database.recipeIngredients,
    )..where((row) => row.recipeId.equals(recipe.id))).go();
    for (var position = 0; position < recipe.ingredients.length; position++) {
      final ingredient = recipe.ingredients[position];
      await _database
          .into(_database.recipeIngredients)
          .insert(
            RecipeIngredientsCompanion.insert(
              recipeId: recipe.id,
              foodId: ingredient.foodId,
              quantityAmount: ingredient.quantity.amount,
              quantityMeasure: ingredient.quantity.measure,
              position: position,
            ),
          );
    }
  });

  @override
  Future<Recipe?> findRecipe(String id) async {
    final row = await (_database.select(
      _database.recipes,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final ingredientRows =
        await (_database.select(_database.recipeIngredients)
              ..where((line) => line.recipeId.equals(id))
              ..orderBy([(line) => OrderingTerm(expression: line.position)]))
            .get();
    return Recipe(
      id: row.id,
      name: row.name,
      yieldServings: row.yieldServings,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      ingredients: ingredientRows
          .map(
            (line) => RecipeIngredient(
              foodId: line.foodId,
              quantity: Quantity(
                amount: line.quantityAmount,
                measure: line.quantityMeasure,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> deleteRecipe(String id) => (_database.delete(
    _database.recipes,
  )..where((row) => row.id.equals(id))).go();
}
