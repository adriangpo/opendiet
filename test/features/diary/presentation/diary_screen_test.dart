import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_diary_repository.dart';
import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides({Clock? clock}) => [
    foodRepositoryProvider.overrideWithValue(FakeFoodRepository()),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
    clockProvider.overrideWithValue(
      clock ?? FixedClock(DateTime.utc(2026, 6, 20)),
    ),
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
          const AsyncData([MealSlot(id: 's1', name: 'Breakfast', position: 0)]),
        ),
      ],
    );

    expect(find.text('+ Add to Breakfast'), findsOneWidget);
  });

  testWidgets('date stepper shows today with day and weekday', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(const AsyncData([])),
      ],
    );

    expect(find.text('Sat'), findsOneWidget);
    expect(find.text('Jun 20'), findsOneWidget);
  });

  testWidgets('date stepper shows Today button', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(const AsyncData([])),
      ],
    );

    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('shows FAB with Add Food tooltip when slots exist', (
    tester,
  ) async {
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

    expect(find.byTooltip('Add Food'), findsOneWidget);
  });

  testWidgets('tapping add-to-slot opens the add food hub', (tester) async {
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

    expect(find.text('Add Food'), findsOneWidget);
  });

  testWidgets('/log without date uses the injected clock day', (tester) async {
    final repository = FakeDiaryRepository();
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(
          clock: FixedClock(DateTime.utc(2030, 1, 2, 10, 30)),
        ),
        diaryRepositoryProvider.overrideWithValue(repository),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([
            MealSlot(id: 's1', name: 'Breakfast', position: 0),
          ]),
        ),
      ],
    );

    final context = tester.element(find.text('Diary').first);
    final pushed = context.push<void>('/log?slot=s1');
    await tester.pump();
    await tester.pump();

    await tester.enterText(find.byKey(const Key('field-name')), 'Pastel');
    await tester.enterText(find.byKey(const Key('field-energy')), '250');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await pushed;

    final entries = await repository.allEntries();
    expect(entries, hasLength(1));
    expect(entries.single.day.year, 2030);
    expect(entries.single.day.month, 1);
    expect(entries.single.day.day, 2);
  });
}
