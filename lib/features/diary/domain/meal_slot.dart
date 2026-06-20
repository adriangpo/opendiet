import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_slot.freezed.dart';
part 'meal_slot.g.dart';

/// The slots in the optional default meal template, ordered through the day
/// (FR-019). [snacks] is the catch-all for foods eaten outside meal times.
/// Their user-facing names are localized at presentation; a slot becomes a
/// fully editable [MealSlot] once the template is applied.
enum DefaultMealSlotKind { breakfast, lunch, dinner, snacks }

/// A user-defined slot the diary is organized into (FR-019).
@freezed
abstract class MealSlot with _$MealSlot {
  /// Creates a meal slot. [position] orders slots within the diary.
  const factory MealSlot({
    required String id,
    required String name,
    required int position,
  }) = _MealSlot;

  /// Builds a meal slot from its JSON form.
  factory MealSlot.fromJson(Map<String, dynamic> json) =>
      _$MealSlotFromJson(json);
}
