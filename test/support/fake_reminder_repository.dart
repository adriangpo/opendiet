import 'package:opendiet/features/reminders/domain/reminder.dart';
import 'package:opendiet/features/reminders/domain/reminder_repository.dart';

/// An in-memory [ReminderRepository] for widget tests.
class FakeReminderRepository implements ReminderRepository {
  final List<Reminder> _reminders = [];

  @override
  Future<List<Reminder>> allReminders() async => List.of(_reminders);

  @override
  Future<void> saveReminder(Reminder reminder) async {
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index >= 0) {
      _reminders[index] = reminder;
    } else {
      _reminders.add(reminder);
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
  }
}
