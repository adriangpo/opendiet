import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/diary/presentation/quick_add_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_diary_repository.dart';
import '../../../support/test_app.dart';

void main() {
  const breakfastSlot = MealSlot(id: 's1', name: 'Breakfast', position: 0);

  // A deterministic stub for id/clock.
  final fixedClock = FixedClock(DateTime.utc(2026, 6, 20, 10, 30));
  final idGenerator = _FixedIdGenerator();

  List<Override> baseOverrides(FakeDiaryRepository repository) => [
    diaryRepositoryProvider.overrideWithValue(repository),
    idGeneratorProvider.overrideWithValue(idGenerator),
    clockProvider.overrideWithValue(fixedClock),
  ];

  Future<void> pumpScreen(
    WidgetTester tester, {
    required FakeDiaryRepository repository,
    String slotId = 's1',
  }) => pumpApp(
    tester,
    QuickAddScreen(
      slotId: slotId,
      day: DateTime.utc(2026, 6, 20),
    ),
    overrides: [
      ...baseOverrides(repository),
      mealSlotsProvider.overrideWithValue(const AsyncData([breakfastSlot])),
    ],
  );

  group('QuickAddScreen', () {
    testWidgets('renders name and energy fields with title from slot', (
      tester,
    ) async {
      await pumpScreen(tester, repository: FakeDiaryRepository());

      expect(find.text('Add to Breakfast'), findsOneWidget);
      expect(find.byKey(const Key('field-name')), findsOneWidget);
      expect(find.byKey(const Key('field-energy')), findsOneWidget);
    });

    testWidgets('shows optional nutrient fields for protein, carbs, fat', (
      tester,
    ) async {
      await pumpScreen(tester, repository: FakeDiaryRepository());

      expect(find.byKey(const Key('field-protein')), findsOneWidget);
      expect(find.byKey(const Key('field-carbohydrates')), findsOneWidget);
      expect(find.byKey(const Key('field-total-fat')), findsOneWidget);
    });

    testWidgets('validates name is required', (tester) async {
      final repository = FakeDiaryRepository();
      await pumpScreen(tester, repository: repository);

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Enter a name'), findsOneWidget);
      expect(repository.allEntries(), completion(isEmpty));
    });

    testWidgets('validates energy is required', (tester) async {
      final repository = FakeDiaryRepository();
      await pumpScreen(tester, repository: repository);

      await tester.enterText(find.byKey(const Key('field-name')), 'Pastel');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Enter valid, non-negative numbers'), findsOneWidget);
      expect(repository.allEntries(), completion(isEmpty));
    });

    testWidgets('validates energy is not negative', (tester) async {
      final repository = FakeDiaryRepository();
      await pumpScreen(tester, repository: repository);

      await tester.enterText(find.byKey(const Key('field-name')), 'Pastel');
      await tester.enterText(find.byKey(const Key('field-energy')), '-5');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Enter valid, non-negative numbers'), findsOneWidget);
      expect(repository.allEntries(), completion(isEmpty));
    });

    testWidgets('saves a quick-add entry and pops back (FR-031)', (
      tester,
    ) async {
      final repository = FakeDiaryRepository();
      await pumpScreen(tester, repository: repository);

      await tester.enterText(find.byKey(const Key('field-name')), 'Pastel');
      await tester.enterText(find.byKey(const Key('field-energy')), '250');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final entries = await repository.allEntries();
      expect(entries, hasLength(1));
      expect(entries.single.label, 'Pastel');
      expect(entries.single.nutrients.energyKcal, 250);
      expect(entries.single.mealSlotId, 's1');
      expect(entries.single.referenceKind, DiaryReferenceKind.quickAdd);
    });

    testWidgets('saves optional nutrients alongside energy', (tester) async {
      final repository = FakeDiaryRepository();
      await pumpScreen(tester, repository: repository);

      await tester.enterText(find.byKey(const Key('field-name')), 'Omelette');
      await tester.enterText(find.byKey(const Key('field-energy')), '300');
      await tester.enterText(find.byKey(const Key('field-protein')), '20');
      await tester.enterText(find.byKey(const Key('field-carbohydrates')), '5');
      await tester.enterText(find.byKey(const Key('field-total-fat')), '15');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final entries = await repository.allEntries();
      expect(entries, hasLength(1));
      final n = entries.single.nutrients;
      expect(n.energyKcal, 300);
      expect(n.protein, 20);
      expect(n.carbohydrates, 5);
      expect(n.totalFat, 15);
    });
  });
}

/// Produces deterministic ids.
class _FixedIdGenerator implements IdGenerator {
  int _counter = 0;

  @override
  String newId() => 'quick-${_counter++}';
}
