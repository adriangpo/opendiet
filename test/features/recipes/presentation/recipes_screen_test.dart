import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
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

  testWidgets('shows empty state when no recipes exist', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();

    await pumpAppShell(
      tester,
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.tap(find.text('Recipes'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('No recipes yet. Build one from your foods.'),
      findsOneWidget,
    );
  });

  testWidgets('displays saved recipes in a list', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
      ]),
    );

    await pumpAppShell(
      tester,
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.tap(find.text('Recipes'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Chicken curry'), findsOneWidget);
  });

  testWidgets('recipe tile shows name and serves count', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
      ]),
    );

    await pumpAppShell(
      tester,
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.tap(find.text('Recipes'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Serves 4'), findsOneWidget);
  });

  testWidgets('FAB navigates to recipe editor', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();

    await pumpAppShell(
      tester,
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.tap(find.text('Recipes'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump();

    expect(find.text('New recipe'), findsOneWidget);
  });

  testWidgets('tapping a recipe navigates to detail', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await recipeRepo.saveRecipe(
      _recipe('r1', 'Chicken curry', [
        RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(200)),
      ]),
    );

    await pumpAppShell(
      tester,
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.tap(find.text('Recipes'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Chicken curry'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Edit'), findsOneWidget);
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

Food _food(String id) => Food(
  id: id,
  name: id,
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(energyKcal: 200),
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);
