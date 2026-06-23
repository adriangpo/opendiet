import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/presentation/food_detail_screen.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides(FakeFoodRepository repository) => [
    foodRepositoryProvider.overrideWithValue(repository),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
    mealSlotsProvider.overrideWithValue(
      const AsyncData([
        MealSlot(id: 'breakfast', name: 'Breakfast', position: 0),
      ]),
    ),
  ];

  testWidgets('shows saved OFF food details and nutrition table', (
    tester,
  ) async {
    final repository = FakeFoodRepository();
    await repository.saveFood(
      _food(
        id: 'oats',
        name: 'Oats',
        brand: 'Generic',
        source: FoodSource.openFoodFacts,
        nutrients: const Nutrients(
          energyKcal: 380,
          carbohydrates: 60,
          protein: 13,
          totalFat: 7,
        ),
      ),
    );

    await pumpApp(
      tester,
      const FoodDetailScreen(foodId: 'oats'),
      overrides: baseOverrides(repository),
    );

    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('Brand: Generic'), findsOneWidget);
    expect(find.text('Source: Open Food Facts'), findsOneWidget);
    expect(find.text('Nutrition facts'), findsOneWidget);
    expect(find.byKey(const Key('nutrition-energy-per100')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Suggest a correction'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Suggest a correction'), findsOneWidget);
  });

  testWidgets('hides OFF correction for local-only food', (tester) async {
    final repository = FakeFoodRepository();
    await repository.saveFood(_food(id: 'rice', name: 'Rice'));

    await pumpApp(
      tester,
      const FoodDetailScreen(foodId: 'rice'),
      overrides: baseOverrides(repository),
    );

    expect(find.text('Rice'), findsOneWidget);
    expect(find.textContaining('Source:'), findsNothing);
    expect(find.text('Suggest a correction'), findsNothing);
  });

  testWidgets('shows not found state for a missing food', (tester) async {
    await pumpApp(
      tester,
      const FoodDetailScreen(foodId: 'missing'),
      overrides: baseOverrides(FakeFoodRepository()),
    );

    expect(find.text('Food not found.'), findsOneWidget);
  });

  testWidgets('favorite button toggles the saved food', (tester) async {
    final repository = FakeFoodRepository();
    await repository.saveFood(_food(id: 'rice', name: 'Rice'));

    await pumpApp(
      tester,
      const FoodDetailScreen(foodId: 'rice'),
      overrides: baseOverrides(repository),
    );

    await tester.tap(find.byKey(const Key('food-detail-favorite-button')));
    await tester.pump();
    await tester.pump();

    expect((await repository.findFood('rice'))!.isFavorite, isTrue);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('edit and log buttons invoke entry point callbacks', (
    tester,
  ) async {
    var editCalled = false;
    var logCalled = false;
    final repository = FakeFoodRepository();
    await repository.saveFood(_food(id: 'rice', name: 'Rice'));

    await pumpApp(
      tester,
      FoodDetailScreen(
        foodId: 'rice',
        onEdit: () => editCalled = true,
        onLog: () => logCalled = true,
      ),
      overrides: baseOverrides(repository),
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('food-detail-edit-button')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('food-detail-edit-button')));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.byKey(const Key('food-detail-log-button')),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('food-detail-log-button')));
    await tester.pump();

    expect(editCalled, isTrue);
    expect(logCalled, isTrue);
  });
}

Food _food({
  required String id,
  required String name,
  String? brand,
  FoodSource source = FoodSource.custom,
  Nutrients nutrients = const Nutrients(energyKcal: 130),
}) => Food(
  id: id,
  name: name,
  brand: brand,
  source: source,
  basis: NutrientBasis.per100g,
  nutrients: nutrients,
  servingSizeMetric: 50,
  servingUnit: ServingUnit.gram,
  householdMeasure: '1 bowl',
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);
