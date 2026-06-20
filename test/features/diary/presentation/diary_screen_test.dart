import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides() => [
    foodRepositoryProvider.overrideWithValue(FakeFoodRepository()),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
  ];

  testWidgets('shows empty state when no meal slots exist', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(const AsyncData([])),
      ],
    );

    expect(
      find.text('No entries yet. Log a food to start your day.'),
      findsOneWidget,
    );
  });

  testWidgets('displays default meal slot headers', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([
            MealSlot(id: 's1', name: 'Breakfast', position: 0),
            MealSlot(id: 's2', name: 'Lunch', position: 1),
          ]),
        ),
      ],
    );

    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
  });

  testWidgets('shows add-to-slot button for each meal slot', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([
            MealSlot(id: 's1', name: 'Breakfast', position: 0),
          ]),
        ),
      ],
    );

    expect(find.text('+ Add to Breakfast'), findsOneWidget);
  });

  testWidgets('tapping add-to-slot navigates to /log (FR-017)', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([
            MealSlot(id: 's1', name: 'Breakfast', position: 0),
          ]),
        ),
      ],
    );

    await tester.tap(find.text('+ Add to Breakfast'));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('field-name')), findsOneWidget);
    expect(find.text('Add to Breakfast'), findsOneWidget);
  });
}
