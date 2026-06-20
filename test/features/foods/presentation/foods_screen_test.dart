import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/data/off_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/fake_off_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides(
    FakeFoodRepository foodRepo, {
    FakeOffRepository? offRepo,
  }) => [
    foodRepositoryProvider.overrideWithValue(foodRepo),
    offRepositoryProvider.overrideWithValue(offRepo ?? FakeOffRepository()),
    mealSlotsProvider.overrideWithValue(const AsyncData([])),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
  ];

  /// Pumps the foods tab by navigating from the default diary tab.
  Future<void> pumpFoodsTab(
    WidgetTester tester,
    List<Override> overrides,
  ) async {
    await pumpAppShell(tester, overrides: overrides);
    await tester.tap(find.text('Foods'));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows empty state when no foods exist', (tester) async {
    await pumpFoodsTab(tester, baseOverrides(FakeFoodRepository()));

    expect(
      find.text('No foods yet. Create a custom food or import a list.'),
      findsOneWidget,
    );
  });

  testWidgets('displays saved foods in a list', (tester) async {
    final repo = FakeFoodRepository();
    await repo.saveFood(_food(name: 'Oats', energy: 180));
    await repo.saveFood(_food(name: 'Banana', energy: 89));

    await pumpFoodsTab(tester, baseOverrides(repo));

    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('shows energy per 100g on food tiles', (tester) async {
    final repo = FakeFoodRepository();
    await repo.saveFood(_food(name: 'Oats', energy: 180));

    await pumpFoodsTab(tester, baseOverrides(repo));

    expect(find.textContaining('180'), findsOneWidget);
  });

  testWidgets('energy shows -- when not informed', (tester) async {
    final repo = FakeFoodRepository();
    await repo.saveFood(_food(name: 'Water'));

    await pumpFoodsTab(tester, baseOverrides(repo));

    expect(find.text('Water'), findsOneWidget);
    expect(find.textContaining('--'), findsOneWidget);
  });

  testWidgets('FAB navigates to food editor', (tester) async {
    await pumpFoodsTab(tester, baseOverrides(FakeFoodRepository()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump();

    expect(find.text('New food'), findsOneWidget);
  });

  testWidgets('search bar filters local foods', (tester) async {
    final repo = FakeFoodRepository();
    await repo.saveFood(_food(name: 'Oats', energy: 180));
    await repo.saveFood(_food(name: 'Banana', energy: 89));

    await pumpFoodsTab(tester, baseOverrides(repo));

    // Initially both foods show, plus the search bar.
    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);

    // Type in the search bar.
    await tester.enterText(find.byType(TextField), 'Oat');
    // Two extra pumps for FutureProvider to resolve.
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
  });

  testWidgets('search shows OFF results alongside local matches', (
    tester,
  ) async {
    final foodRepo = FakeFoodRepository();
    final offRepo = FakeOffRepository();
    await foodRepo.saveFood(_food(name: 'Oats', energy: 180));
    await foodRepo.saveFood(_food(name: 'Banana', energy: 89));

    // Add an OFF result.
    await offRepo.saveProduct(
      _food(name: 'Oat Milk', energy: 45, source: FoodSource.openFoodFacts),
    );
    await offRepo.saveProduct(
      _food(name: 'Oat Bread', energy: 250, source: FoodSource.openFoodFacts),
    );

    await pumpFoodsTab(
      tester,
      baseOverrides(foodRepo, offRepo: offRepo),
    );

    // Clear initial state - check search results.
    await tester.enterText(find.byType(TextField), 'Oat');
    // Three extra pumps for FutureProvider + OFF search to resolve.
    await tester.pump();
    await tester.pump();
    await tester.pump();

    // Local + OFF matches shown.
    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('Oat Milk'), findsOneWidget);
    expect(find.text('Oat Bread'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
  });
}

Food _food({
  required String name,
  double? energy,
  FoodSource source = FoodSource.custom,
}) => Food(
  id: name,
  name: name,
  source: source,
  basis: NutrientBasis.per100g,
  nutrients: Nutrients(energyKcal: energy),
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);
