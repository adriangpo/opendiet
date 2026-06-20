import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/data/drift_diary_repository.dart';
import 'package:opendiet/features/diary/data/drift_meal_slot_repository.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';

void main() {
  late AppDatabase database;
  late DriftDiaryRepository repository;

  DiaryEntry entry(String id, DateTime day, {double energy = 100}) =>
      DiaryEntry(
        id: id,
        day: day,
        mealSlotId: 'breakfast',
        referenceKind: DiaryReferenceKind.food,
        referenceId: 'food',
        label: 'Food',
        quantity: Quantity.servings(1),
        nutrients: Nutrients(energyKcal: energy),
        loggedAt: day,
      );

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftDiaryRepository(database);
    await DriftMealSlotRepository(
      database,
    ).saveMealSlot(
      const MealSlot(id: 'breakfast', name: 'Breakfast', position: 0),
    );
  });
  tearDown(() => database.close());

  test('round-trips a diary entry', () async {
    final e = entry('e1', DateTime.utc(2026, 6, 19, 8));

    await repository.saveEntry(e);

    expect(await repository.findEntry('e1'), e);
  });

  test('entriesForDay returns only that calendar day', () async {
    await repository.saveEntry(entry('e1', DateTime.utc(2026, 6, 19, 8)));
    await repository.saveEntry(entry('e2', DateTime.utc(2026, 6, 19, 20)));
    await repository.saveEntry(entry('e3', DateTime.utc(2026, 6, 20, 8)));

    final entries = await repository.entriesForDay(DateTime.utc(2026, 6, 19));

    expect(entries.map((e) => e.id), unorderedEquals(['e1', 'e2']));
  });

  test(
    'round-trips a quick-add entry with no catalog reference (FR-031)',
    () async {
      final quick = DiaryEntry(
        id: 'q1',
        day: DateTime.utc(2026, 6, 19),
        mealSlotId: 'breakfast',
        referenceKind: DiaryReferenceKind.quickAdd,
        label: 'Pastel',
        quantity: Quantity.servings(1),
        nutrients: const Nutrients(energyKcal: 250),
        loggedAt: DateTime.utc(2026, 6, 19, 12),
      );

      await repository.saveEntry(quick);

      final restored = await repository.findEntry('q1');
      expect(restored, quick);
      expect(restored!.referenceId, isNull);
    },
  );

  test('deleteEntry removes the entry', () async {
    await repository.saveEntry(entry('e1', DateTime.utc(2026, 6, 19)));

    await repository.deleteEntry('e1');

    expect(await repository.findEntry('e1'), isNull);
  });

  test('rejects an entry whose meal slot does not exist (FR-023)', () async {
    final orphan = entry(
      'e1',
      DateTime.utc(2026, 6, 19),
    ).copyWith(mealSlotId: 'ghost');

    await expectLater(
      repository.saveEntry(orphan),
      throwsA(isA<Exception>()),
    );
  });
}
