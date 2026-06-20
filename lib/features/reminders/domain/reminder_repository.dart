import 'package:opendiet/features/reminders/domain/reminder.dart';

/// Persists and retrieves mealtime reminders (FR-020).
abstract interface class ReminderRepository {
  /// All saved reminders.
  Future<List<Reminder>> allReminders();

  /// Persists [reminder], inserting or updating.
  Future<void> saveReminder(Reminder reminder);

  /// Deletes the reminder identified by [id].
  Future<void> deleteReminder(String id);
}
