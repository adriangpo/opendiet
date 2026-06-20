import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/diary_totals.dart';

DiaryEntry _entry({required DateTime day, required Nutrients nutrients}) =>
    DiaryEntry(
      id: 'e-${day.toIso8601String()}-${nutrients.energyKcal}',
      day: day,
      mealSlotId: 'breakfast',
      referenceKind: DiaryReferenceKind.food,
      referenceId: 'food',
      label: 'Food',
      quantity: Quantity.servings(1),
      nutrients: nutrients,
      loggedAt: day,
    );

void main() {
  group('DiaryTotals.forEntries (FR-004)', () {
    test('sums every entry nutrient snapshot', () {
      final entries = [
        _entry(
          day: DateTime.utc(2026, 6, 19),
          nutrients: const Nutrients(energyKcal: 200, protein: 10),
        ),
        _entry(
          day: DateTime.utc(2026, 6, 19),
          nutrients: const Nutrients(energyKcal: 350, totalFat: 5),
        ),
      ];

      final total = DiaryTotals.forEntries(entries);

      expect(total.energyKcal, 550);
      expect(total.protein, 10);
      expect(total.totalFat, 5);
    });

    test('no entries total to all-absent', () {
      expect(DiaryTotals.forEntries(const []), Nutrients.empty);
    });
  });

  group('DiaryTotals.forDay', () {
    test('includes only entries on the given calendar day', () {
      final entries = [
        _entry(
          day: DateTime.utc(2026, 6, 19, 8),
          nutrients: const Nutrients(energyKcal: 200),
        ),
        _entry(
          day: DateTime.utc(2026, 6, 19, 20),
          nutrients: const Nutrients(energyKcal: 300),
        ),
        _entry(
          day: DateTime.utc(2026, 6, 20, 8),
          nutrients: const Nutrients(energyKcal: 999),
        ),
      ];

      final total = DiaryTotals.forDay(entries, DateTime.utc(2026, 6, 19));

      expect(total.energyKcal, 500);
    });
  });

  group('DailyTargetComparison.remaining (FR-022)', () {
    test('is the target minus what has been consumed', () {
      const totals = Nutrients(energyKcal: 1500);
      const target = Nutrients(energyKcal: 2000);

      expect(
        DailyTargetComparison.remaining(totals, target, Nutrient.energy),
        closeTo(500, 1e-9),
      );
    });

    test('is negative when consumption is over target', () {
      const totals = Nutrients(energyKcal: 2200);
      const target = Nutrients(energyKcal: 2000);

      expect(
        DailyTargetComparison.remaining(totals, target, Nutrient.energy),
        closeTo(-200, 1e-9),
      );
    });

    test('treats an absent total as zero consumed', () {
      const totals = Nutrients.empty;
      const target = Nutrients(energyKcal: 2000);

      expect(
        DailyTargetComparison.remaining(totals, target, Nutrient.energy),
        closeTo(2000, 1e-9),
      );
    });

    test('is null when no target is set for the nutrient', () {
      const totals = Nutrients(energyKcal: 1500);

      expect(
        DailyTargetComparison.remaining(totals, null, Nutrient.energy),
        isNull,
      );
      expect(
        DailyTargetComparison.remaining(
          totals,
          const Nutrients(protein: 100),
          Nutrient.energy,
        ),
        isNull,
      );
    });
  });
}
