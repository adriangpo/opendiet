import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/features/diary/domain/default_meal_slots.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';

/// Deterministic ids so positions and order can be asserted exactly.
class _SequentialIds implements IdGenerator {
  int _next = 0;
  @override
  String newId() => 'id-${_next++}';
}

String _english(DefaultMealSlotKind kind) => switch (kind) {
  DefaultMealSlotKind.breakfast => 'Breakfast',
  DefaultMealSlotKind.lunch => 'Lunch',
  DefaultMealSlotKind.dinner => 'Dinner',
  DefaultMealSlotKind.snacks => 'Snacks',
};

void main() {
  group('DefaultMealSlots.build (FR-019)', () {
    test('builds the template in day order with sequential positions', () {
      final slots = DefaultMealSlots.build(
        localizedName: _english,
        idGenerator: _SequentialIds(),
      );

      expect(slots.map((slot) => slot.name), [
        'Breakfast',
        'Lunch',
        'Dinner',
        'Snacks',
      ]);
      expect(slots.map((slot) => slot.position), [0, 1, 2, 3]);
      expect(slots.map((slot) => slot.id), ['id-0', 'id-1', 'id-2', 'id-3']);
    });

    test('always includes a snack slot for off-meal foods', () {
      final slots = DefaultMealSlots.build(
        localizedName: (kind) => kind.name,
        idGenerator: _SequentialIds(),
      );

      expect(
        slots.any((slot) => slot.name == DefaultMealSlotKind.snacks.name),
        isTrue,
      );
    });
  });
}
