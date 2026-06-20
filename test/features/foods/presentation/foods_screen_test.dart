import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides(FakeFoodRepository repo) => [
    foodRepositoryProvider.overrideWithValue(repo),
    mealSlotsProvider.overrideWithValue(const AsyncData([])),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
  ];

  testWidgets('shows empty state when no foods exist', (tester) async {
    await pumpAppShell(tester, overrides: baseOverrides(FakeFoodRepository()));

    await tester.tap(find.text('Foods'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('No foods yet. Create a custom food or import a list.'),
      findsOneWidget,
    );
  });

  testWidgets('displays saved foods in a list', (tester) async {
    final repository = FakeFoodRepository();
    await repository.saveFood(
      _food(name: 'Oats', energy: 180),
    );
    await repository.saveFood(
      _food(name: 'Banana', energy: 89),
    );

    await pumpAppShell(tester, overrides: baseOverrides(repository));

    await tester.tap(find.text('Foods'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('shows energy per 100g on food tiles', (tester) async {
    final repository = FakeFoodRepository();
    await repository.saveFood(
      _food(name: 'Oats', energy: 180),
    );

    await pumpAppShell(tester, overrides: baseOverrides(repository));

    await tester.tap(find.text('Foods'));
    await tester.pump();
    await tester.pump();

    expect(find.textContaining('180'), findsOneWidget);
  });

  testWidgets('energy shows -- when not informed', (tester) async {
    final repository = FakeFoodRepository();
    await repository.saveFood(
      _food(name: 'Water'),
    );

    await pumpAppShell(tester, overrides: baseOverrides(repository));

    await tester.tap(find.text('Foods'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Water'), findsOneWidget);
    expect(find.textContaining('--'), findsOneWidget);
  });

  testWidgets('FAB navigates to food editor', (tester) async {
    await pumpAppShell(tester, overrides: baseOverrides(FakeFoodRepository()));

    await tester.tap(find.text('Foods'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump();

    expect(find.text('New food'), findsOneWidget);
  });
}

Food _food({required String name, double? energy}) => Food(
  id: name,
  name: name,
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: Nutrients(energyKcal: energy),
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);
