import 'package:opendiet/features/diary/domain/meal_slot.dart';

/// Persists and retrieves the user's meal slots (FR-019).
abstract interface class MealSlotRepository {
  /// Inserts or updates [slot].
  Future<void> saveMealSlot(MealSlot slot);

  /// Every meal slot ordered by position.
  Future<List<MealSlot>> allMealSlots();

  /// Removes the meal slot with [id].
  Future<void> deleteMealSlot(String id);
}
