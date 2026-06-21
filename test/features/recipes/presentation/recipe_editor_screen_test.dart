import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/presentation/recipe_editor_screen.dart';
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

  testWidgets('shows empty form for new recipe', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();

    await pumpApp(
      tester,
      const RecipeEditorScreen(),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    expect(find.text('New recipe'), findsOneWidget);
    expect(find.byKey(const Key('recipe-editor-name-field')), findsOneWidget);
    expect(find.byKey(const Key('recipe-editor-yield-field')), findsOneWidget);
    expect(
      find.byKey(const Key('recipe-add-ingredient-button')),
      findsOneWidget,
    );
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('shows validation error when name is empty', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();

    await pumpApp(
      tester,
      const RecipeEditorScreen(),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Enter a recipe name'), findsOneWidget);
    expect(recipeRepo.lastSaved, isNull);
  });

  testWidgets('shows validation error when no ingredients', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();

    await pumpApp(
      tester,
      const RecipeEditorScreen(),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.enterText(
      find.byKey(const Key('recipe-editor-name-field')),
      'My Recipe',
    );
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Add at least one ingredient'), findsOneWidget);
    expect(recipeRepo.lastSaved, isNull);
  });

  testWidgets('shows validation error when yield is empty', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();

    await pumpApp(
      tester,
      const RecipeEditorScreen(),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.enterText(
      find.byKey(const Key('recipe-editor-name-field')),
      'My Recipe',
    );
    await tester.enterText(
      find.byKey(const Key('recipe-editor-yield-field')),
      '',
    );
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Yield must be at least 1'), findsOneWidget);
    expect(recipeRepo.lastSaved, isNull);
  });

  testWidgets('saves a recipe with name, yield, and ingredients', (
    tester,
  ) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));

    await pumpApp(
      tester,
      const RecipeEditorScreen(),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    await tester.enterText(
      find.byKey(const Key('recipe-editor-name-field')),
      'Chicken curry',
    );

    await tester.tap(find.byKey(const Key('recipe-add-ingredient-button')));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('chicken'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(recipeRepo.lastSaved, isNotNull);
    expect(recipeRepo.lastSaved!.name, 'Chicken curry');
    expect(recipeRepo.lastSaved!.ingredients, hasLength(1));
  });

  testWidgets('pre-fills fields when editing existing recipe', (tester) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    const recipeId = 'r1';
    await recipeRepo.saveRecipe(
      Recipe(
        id: recipeId,
        name: 'Chicken curry',
        yieldServings: 4,
        ingredients: [
          RecipeIngredient(foodId: 'chicken', quantity: Quantity.grams(300)),
        ],
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      ),
    );

    await pumpApp(
      tester,
      const RecipeEditorScreen(recipeId: recipeId),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Edit recipe'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Chicken curry'), findsOneWidget);
    expect(find.text('chicken'), findsOneWidget);
  });

  testWidgets('removing an ingredient removes it from the list', (
    tester,
  ) async {
    final recipeRepo = FakeRecipeRepository();
    final foodRepo = FakeFoodRepository();
    await foodRepo.saveFood(_food('chicken'));
    await foodRepo.saveFood(_food('onion'));

    await pumpApp(
      tester,
      const RecipeEditorScreen(),
      overrides: baseOverrides(recipeRepo: recipeRepo, foodRepo: foodRepo),
    );

    // Add first ingredient
    await tester.tap(find.byKey(const Key('recipe-add-ingredient-button')));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('chicken'));
    await tester.pump();
    await tester.pump();

    // Add second ingredient
    await tester.tap(find.byKey(const Key('recipe-add-ingredient-button')));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('onion'));
    await tester.pump();
    await tester.pump();

    expect(find.text('chicken'), findsOneWidget);
    expect(find.text('onion'), findsOneWidget);

    // Delete first ingredient
    await tester.tap(find.byKey(const Key('recipe-delete-ingredient-0')));
    await tester.pump();

    expect(find.text('chicken'), findsNothing);
    expect(find.text('onion'), findsOneWidget);
  });
}

Food _food(String id) => Food(
  id: id,
  name: id,
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(energyKcal: 200),
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);
