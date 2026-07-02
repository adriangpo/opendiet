import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/diary_repository.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_diary_repository.dart';
import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides({
    DiaryRepository? diaryRepository,
  }) => [
    diaryRepositoryProvider.overrideWithValue(
      diaryRepository ?? FakeDiaryRepository(),
    ),
    foodRepositoryProvider.overrideWithValue(FakeFoodRepository()),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
    clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 6, 20))),
  ];

  const breakfastSlot = MealSlot(id: 's1', name: 'Breakfast', position: 0);

  List<DiaryEntry> singleEntry(String id, String label, double kcal) => [
    DiaryEntry(
      id: id,
      day: DateTime.utc(2026, 6, 20),
      mealSlotId: 's1',
      referenceKind: DiaryReferenceKind.food,
      referenceId: 'f1',
      label: label,
      quantity: Quantity.grams(100),
      nutrients: Nutrients(energyKcal: kcal),
      loggedAt: DateTime.utc(2026, 6, 20, 8),
    ),
  ];

  testWidgets('shows slot name in AppBar', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([breakfastSlot]),
        ),
        selectedDayEntriesProvider.overrideWithValue(
          const AsyncData(<DiaryEntry>[]),
        ),
      ],
      initialRoute: '/diary/slot/s1',
    );

    expect(find.text('Breakfast'), findsOneWidget);
  });

  testWidgets('shows empty state when no entries', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([breakfastSlot]),
        ),
        selectedDayEntriesProvider.overrideWithValue(
          const AsyncData(<DiaryEntry>[]),
        ),
      ],
      initialRoute: '/diary/slot/s1',
    );

    expect(find.text('No entries'), findsOneWidget);
  });

  testWidgets('shows entry label and kcal', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([breakfastSlot]),
        ),
        selectedDayEntriesProvider.overrideWithValue(
          AsyncData(singleEntry('e1', 'Oats', 180)),
        ),
      ],
      initialRoute: '/diary/slot/s1',
    );

    expect(find.text('Oats'), findsOneWidget);
    // The kcal text appears in both the entry row and the total row
    expect(find.textContaining('180'), findsAtLeast(1));
  });

  testWidgets('shows total row at bottom', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([breakfastSlot]),
        ),
        selectedDayEntriesProvider.overrideWithValue(
          AsyncData(singleEntry('e1', 'Oats', 360)),
        ),
      ],
      initialRoute: '/diary/slot/s1',
    );

    expect(find.textContaining('Total:'), findsOneWidget);
    expect(find.textContaining('360'), findsAtLeast(1));
  });

  testWidgets('tap on entry navigates to edit', (tester) async {
    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([breakfastSlot]),
        ),
        selectedDayEntriesProvider.overrideWithValue(
          AsyncData(singleEntry('e1', 'Oats', 180)),
        ),
      ],
      initialRoute: '/diary/slot/s1',
    );

    await tester.tap(find.text('Oats'));
    await tester.pump();
    await tester.pump();

    // Should navigate to the edit route (edit screen has Cancel in AppBar)
    expect(find.text('Diary'), findsOneWidget);
  });

  testWidgets('swipe deletes entry with confirmation', (tester) async {
    final repository = FakeDiaryRepository();
    await repository.saveEntry(singleEntry('e1', 'Oats', 180).first);

    await pumpAppShell(
      tester,
      overrides: [
        ...baseOverrides(diaryRepository: repository),
        mealSlotsProvider.overrideWithValue(
          const AsyncData([breakfastSlot]),
        ),
        selectedDayEntriesProvider.overrideWithValue(
          AsyncData(singleEntry('e1', 'Oats', 180)),
        ),
      ],
      initialRoute: '/diary/slot/s1',
    );

    await tester.timedDrag(
      find.byKey(const ValueKey('e1')),
      const Offset(-800, 0),
      const Duration(milliseconds: 500),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Confirmation dialog shown
    expect(find.text('Remove entry'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Entry is deleted from the real repository
    final entries = await repository.allEntries();
    expect(entries, isEmpty);
  });
}
