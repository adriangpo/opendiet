import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/quick_add.dart';

DiaryEntry _entry({String name = 'Pastel', double energyKcal = 250}) =>
    QuickAdd.entry(
      id: 'q1',
      mealSlotId: 'lunch',
      day: DateTime.utc(2026, 6, 19),
      loggedAt: DateTime.utc(2026, 6, 19, 12),
      name: name,
      energyKcal: energyKcal,
    );

void main() {
  group('QuickAdd.entry', () {
    test('builds an ad-hoc entry not backed by any catalog food (FR-031)', () {
      final entry = _entry();

      expect(entry.referenceKind, DiaryReferenceKind.quickAdd);
      expect(entry.referenceId, isNull);
      expect(entry.label, 'Pastel');
      expect(entry.nutrients.energyKcal, 250);
      expect(entry.quantity, Quantity.servings(1));
    });

    test('keeps additional nutrients alongside the energy value', () {
      final entry = QuickAdd.entry(
        id: 'q1',
        mealSlotId: 'lunch',
        day: DateTime.utc(2026, 6, 19),
        loggedAt: DateTime.utc(2026, 6, 19, 12),
        name: 'Pastel',
        energyKcal: 250,
        additionalNutrients: const Nutrients(protein: 8),
      );

      expect(entry.nutrients.energyKcal, 250);
      expect(entry.nutrients.protein, 8);
    });

    test('rejects a blank name (FR-023)', () {
      expect(
        () => _entry(name: '   '),
        throwsArgumentError,
      );
    });

    test('rejects a negative or non-finite energy (FR-023)', () {
      expect(() => _entry(energyKcal: -1), throwsArgumentError);
      expect(() => _entry(energyKcal: double.nan), throwsArgumentError);
    });
  });
}
