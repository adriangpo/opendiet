import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/diary/domain/meal_slot_repository.dart';

/// An in-memory [MealSlotRepository] for widget tests.
class FakeMealSlotRepository implements MealSlotRepository {
  final List<MealSlot> _slots = [];

  @override
  Future<void> saveMealSlot(MealSlot slot) async {
    final index = _slots.indexWhere((s) => s.id == slot.id);
    if (index >= 0) {
      _slots[index] = slot;
    } else {
      _slots.add(slot);
    }
    _slots.sort((a, b) => a.position.compareTo(b.position));
  }

  @override
  Future<List<MealSlot>> allMealSlots() async => List.of(_slots);

  @override
  Future<void> deleteMealSlot(String id) async =>
      _slots.removeWhere((s) => s.id == id);
}
