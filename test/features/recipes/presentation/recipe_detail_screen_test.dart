import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/presentation/recipe_detail_screen.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/fake_recipe_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides({
    required FakeRecipeRepository recipeRepo,
    required FakeFoodRepository foodRepo,
  }) => [
    recipeRepositoryProvider.overrideWithValue(recipeRepo),
    foodRepositoryProvider.overrideWithValue(foodRepo),
    mealSlotsProvider.overrideWithValue(const AsyncData([])),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
  ];

  testWidgets('shows recipe name and serves count', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
      ]),
    );

    await pumpApp(
      tester,
      RecipeDetailScreen(recipeId: 'r1'),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Chicken curry'), findsOneWidget);
    expect(find.text('Serves 4'), findsOneWidget);
  });

  testWidgets('shows per-serving and total nutrition', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken', energy: 200));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
      ]),
    );

    await pumpApp(
      tester,
      RecipeDetailScreen(recipeId: 'r1'),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );
    await tester.pump();
    await tester.pump();

    // 200 kcal per 100g * 200g = 400 kcal total / 4 servings = 100 kcal per serving
    expect(find.text('Per serving'), findsOneWidget);
    expect(find.text('Whole recipe'), findsOneWidget);
    expect(find.textContaining('100'), findsOneWidget);
    expect(find.textContaining('400'), findsOneWidget);
  });

  testWidgets('shows ingredient list', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await foodRepo.saveFood(_food('onion'));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
        RecipeIngredient(foodId: 'onion', quantity: Quantity.grams(100)),
      ]),
    );

    await pumpApp(
      tester,
      RecipeDetailScreen(recipeId: 'r1'),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('chicken'), findsOneWidget);
    expect(find.text('onion'), findsOneWidget);
  });

  testWidgets('edit button invokes onEdit callback', (tester) async {
    var editCalled = false;
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
      ]),
    );

    await pumpApp(
      tester,
      RecipeDetailScreen(
        recipeId: 'r1',
        onEdit: () => editCalled = true,
      ),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byKey(const Key('recipe-detail-edit-button')));
    await tester.pump();

    expect(editCalled, isTrue);
  });

  testWidgets('log servings button is present', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
      ]),
    );

    await pumpApp(
      tester,
      RecipeDetailScreen(recipeId: 'r1'),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('recipe-detail-log-button')), findsOneWidget);
  });
}

Recipe _recipe(String id, String name, List<RecipeIngredient> ingredients) =>
    Recipe(
      id: id,
      name: name,
      yieldServings: 4,
      ingredients: ingredients,
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    );

Food _food(String id, {double? energy}) => Food(
  id: id,
  name: id,
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: Nutrients(energyKcal: energy ?? 200),
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);
