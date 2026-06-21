import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/diary/presentation/food_quantity_entry_screen.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_diary_repository.dart';
import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides({
    required FakeFoodRepository foodRepository,
    required FakeDiaryRepository diaryRepository,
    List<MealSlot> slots = const [
      MealSlot(id: 'breakfast', name: 'Breakfast', position: 0),
    ],
  }) => [
    foodRepositoryProvider.overrideWithValue(foodRepository),
    diaryRepositoryProvider.overrideWithValue(diaryRepository),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
    idGeneratorProvider.overrideWithValue(_FixedIdGenerator('entry-1')),
    clockProvider.overrideWithValue(
      FixedClock(DateTime.utc(2026, 6, 20, 10, 30)),
    ),
    mealSlotsProvider.overrideWithValue(AsyncData(slots)),
  ];

  testWidgets(
    'shows food, default serving quantity, preview, and target meal',
    (
      tester,
    ) async {
      final foods = FakeFoodRepository();
      final diary = FakeDiaryRepository();
      await foods.saveFood(_food(id: 'oats', name: 'Oats'));

      await pumpApp(
        tester,
        FoodQuantityEntryScreen(
          foodId: 'oats',
          day: DateTime.utc(2026, 6, 20),
        ),
        overrides: baseOverrides(foodRepository: foods, diaryRepository: diary),
      );

      expect(find.text('Oats'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('For this amount'), findsOneWidget);
      expect(find.textContaining('190'), findsOneWidget);
    },
  );

  testWidgets('hides servings option when food has no serving size', (
    tester,
  ) async {
    final foods = FakeFoodRepository();
    final diary = FakeDiaryRepository();
    await foods.saveFood(
      _food(id: 'oil', name: 'Oil', servingSizeMetric: null),
    );

    await pumpApp(
      tester,
      FoodQuantityEntryScreen(
        foodId: 'oil',
        day: DateTime.utc(2026, 6, 20),
      ),
      overrides: baseOverrides(foodRepository: foods, diaryRepository: diary),
    );

    expect(find.text('servings'), findsNothing);
  });

  testWidgets('logs the selected amount to the diary', (tester) async {
    final foods = FakeFoodRepository();
    final diary = FakeDiaryRepository();
    await foods.saveFood(_food(id: 'oats', name: 'Oats'));

    await pumpApp(
      tester,
      FoodQuantityEntryScreen(
        foodId: 'oats',
        day: DateTime.utc(2026, 6, 20),
      ),
      overrides: baseOverrides(foodRepository: foods, diaryRepository: diary),
    );

    await tester.tap(find.text('Add to diary'));
    await tester.pump();

    final entries = await diary.allEntries();
    expect(entries, hasLength(1));
    expect(entries.single.id, 'entry-1');
    expect(entries.single.referenceKind, DiaryReferenceKind.food);
    expect(entries.single.referenceId, 'oats');
    expect(entries.single.mealSlotId, 'breakfast');
    expect(entries.single.quantity, Quantity.servings(1));
    expect(entries.single.nutrients.energyKcal, 190);
    expect((await foods.findFood('oats'))!.lastLoggedAt, isNotNull);
  });

  testWidgets('disables saving when quantity is invalid', (tester) async {
    final foods = FakeFoodRepository();
    final diary = FakeDiaryRepository();
    await foods.saveFood(_food(id: 'oats', name: 'Oats'));

    await pumpApp(
      tester,
      FoodQuantityEntryScreen(
        foodId: 'oats',
        day: DateTime.utc(2026, 6, 20),
      ),
      overrides: baseOverrides(foodRepository: foods, diaryRepository: diary),
    );

    await tester.enterText(find.byKey(const Key('quantity-amount')), '-1');
    await tester.pump();

    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('food-quantity-save-button')),
          )
          .onPressed,
      isNull,
    );
  });
}

Food _food({
  required String id,
  required String name,
  double? servingSizeMetric = 50,
}) => Food(
  id: id,
  name: name,
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(
    energyKcal: 380,
    carbohydrates: 60,
    protein: 13,
    totalFat: 7,
  ),
  servingSizeMetric: servingSizeMetric,
  servingUnit: ServingUnit.gram,
  householdMeasure: '1 bowl',
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

class _FixedIdGenerator implements IdGenerator {
  _FixedIdGenerator(this.id);

  final String id;

  @override
  String newId() => id;
}
