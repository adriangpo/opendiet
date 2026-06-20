import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/foods/data/drift_food_repository.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/drift_recipe_repository.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';

Food _food(String id) => Food(
  id: id,
  name: 'Food $id',
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(energyKcal: 100),
  createdAt: DateTime.utc(2026, 6, 19),
  updatedAt: DateTime.utc(2026, 6, 19),
);

void main() {
  late AppDatabase database;
  late DriftRecipeRepository repository;

  Recipe recipe(List<RecipeIngredient> ingredients) => Recipe(
    id: 'r1',
    name: 'Cake',
    yieldServings: 8,
    ingredients: ingredients,
    createdAt: DateTime.utc(2026, 6, 19),
    updatedAt: DateTime.utc(2026, 6, 19),
  );

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRecipeRepository(database);
    final foods = DriftFoodRepository(database);
    await foods.saveFood(_food('flour'));
    await foods.saveFood(_food('sugar'));
  });
  tearDown(() => database.close());

  test('round-trips a recipe and its ingredients in order', () async {
    final r = recipe([
      RecipeIngredient(foodId: 'flour', quantity: Quantity.grams(200)),
      RecipeIngredient(foodId: 'sugar', quantity: Quantity.servings(2)),
    ]);

    await repository.saveRecipe(r);

    expect(await repository.findRecipe('r1'), r);
  });

  test('re-saving a recipe replaces its ingredients atomically', () async {
    await repository.saveRecipe(
      recipe([
        RecipeIngredient(foodId: 'flour', quantity: Quantity.grams(200)),
        RecipeIngredient(foodId: 'sugar', quantity: Quantity.grams(100)),
      ]),
    );
    await repository.saveRecipe(
      recipe([
        RecipeIngredient(foodId: 'flour', quantity: Quantity.grams(150)),
      ]),
    );

    expect((await repository.findRecipe('r1'))!.ingredients, hasLength(1));
  });

  test('deleting a recipe cascades to its ingredients', () async {
    await repository.saveRecipe(
      recipe([
        RecipeIngredient(foodId: 'flour', quantity: Quantity.grams(200)),
      ]),
    );

    await repository.deleteRecipe('r1');

    expect(await repository.findRecipe('r1'), isNull);
    final remaining = await database.select(database.recipeIngredients).get();
    expect(remaining, isEmpty);
  });

  test(
    'a recipe with an unknown ingredient food is rejected atomically',
    () async {
      final bad = recipe([
        RecipeIngredient(foodId: 'ghost', quantity: Quantity.grams(10)),
      ]);

      await expectLater(repository.saveRecipe(bad), throwsA(isA<Exception>()));
      // The whole save rolled back: no orphaned recipe row (FR-023, NFR-004).
      expect(await repository.findRecipe('r1'), isNull);
    },
  );
}
