import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart' show MealSlot;

part 'reminder.freezed.dart';
part 'reminder.g.dart';

/// A mealtime reminder configuration (FR-020).
///
/// Each reminder has a time (hour:minute), an enabled flag, and an
/// optional reference to a [MealSlot].
@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required int hour,
    required int minute,
    required bool enabled,
    String? mealSlotId,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}
