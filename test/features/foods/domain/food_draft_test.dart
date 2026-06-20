import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/diary/domain/quick_add.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_draft.dart';

void main() {
  group('FoodDraft.create', () {
    test('produces a blank automatic-energy custom food', () {
      final food = FoodDraft.create(id: 'f1', now: DateTime.utc(2026, 6, 19));

      expect(food.source, FoodSource.custom);
      expect(food.name, isEmpty);
      expect(food.energyIsManual, isFalse);
      expect(food.nutrients, Nutrients.empty);
    });

    test('carries over a name and nutrients with a chosen basis', () {
      final food = FoodDraft.create(
        id: 'f1',
        now: DateTime.utc(2026, 6, 19),
        name: 'Granola',
        nutrients: const Nutrients(energyKcal: 120, protein: 4),
        basis: NutrientBasis.per100g,
        energyIsManual: true,
      );

      expect(food.name, 'Granola');
      expect(food.basis, NutrientBasis.per100g);
      expect(food.nutrients.energyKcal, 120);
      expect(food.energyIsManual, isTrue);
    });
  });

  group('promoting a quick-added entry (FR-031)', () {
    test('drafts a per-serving custom food from the entry snapshot', () {
      final entry = QuickAdd.entry(
        id: 'q1',
        mealSlotId: 'lunch',
        day: DateTime.utc(2026, 6, 19),
        loggedAt: DateTime.utc(2026, 6, 19, 12),
        name: 'Pastel',
        energyKcal: 250,
      );

      final draft = FoodDraft.create(
        id: 'f1',
        now: DateTime.utc(2026, 6, 19),
        name: entry.label,
        nutrients: entry.nutrients,
        energyIsManual: true,
      );

      expect(draft.name, 'Pastel');
      expect(draft.nutrients.energyKcal, 250);
      // The user typed the kcal, so energy stays theirs until handed back.
      expect(draft.energyIsManual, isTrue);
      expect(draft.basis, NutrientBasis.perServing);
    });
  });
}
