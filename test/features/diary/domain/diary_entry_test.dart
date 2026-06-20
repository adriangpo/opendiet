import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';

void main() {
  group('DiaryEntry', () {
    test('round-trips through json, preserving its nutrient snapshot', () {
      final entry = DiaryEntry(
        id: 'e1',
        day: DateTime.utc(2026, 6, 19),
        mealSlotId: 'breakfast',
        referenceKind: DiaryReferenceKind.food,
        referenceId: 'yogurt',
        label: 'Greek Yogurt',
        quantity: Quantity.servings(1),
        nutrients: const Nutrients(energyKcal: 100, protein: 17),
        loggedAt: DateTime.utc(2026, 6, 19, 8, 30),
      );

      final restored = DiaryEntry.fromJson(entry.toJson());

      expect(restored, entry);
      expect(restored.referenceKind, DiaryReferenceKind.food);
      expect(restored.nutrients.protein, 17);
    });
  });

  group('MealSlot', () {
    test('round-trips through json', () {
      const slot = MealSlot(id: 's1', name: 'Cafe da manha', position: 0);

      expect(MealSlot.fromJson(slot.toJson()), slot);
    });

    test('default template kinds are ordered through the day', () {
      expect(DefaultMealSlotKind.values, <DefaultMealSlotKind>[
        DefaultMealSlotKind.breakfast,
        DefaultMealSlotKind.lunch,
        DefaultMealSlotKind.dinner,
        DefaultMealSlotKind.snacks,
      ]);
    });
  });
}
