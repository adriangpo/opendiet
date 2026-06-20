import 'package:drift/drift.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';
import 'package:opendiet/features/reminders/domain/reminder_repository.dart';

/// Drift-backed [ReminderRepository].
class DriftReminderRepository implements ReminderRepository {
  /// Creates a repository over [_database].
  DriftReminderRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Reminder>> allReminders() async {
    final rows = await _database.select(_database.reminders).get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> saveReminder(Reminder reminder) => _database
      .into(_database.reminders)
      .insertOnConflictUpdate(
        RemindersCompanion(
          id: Value(reminder.id),
          hour: Value(reminder.hour),
          minute: Value(reminder.minute),
          enabled: Value(reminder.enabled),
          mealSlotId: Value(reminder.mealSlotId),
        ),
      );

  @override
  Future<void> deleteReminder(String id) => (_database.delete(
    _database.reminders,
  )..where((row) => row.id.equals(id))).go();

  Reminder _toDomain(ReminderRow row) => Reminder(
    id: row.id,
    hour: row.hour,
    minute: row.minute,
    enabled: row.enabled,
    mealSlotId: row.mealSlotId,
  );
}
