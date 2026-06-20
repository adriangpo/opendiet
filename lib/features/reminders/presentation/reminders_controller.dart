import 'package:opendiet/features/reminders/data/reminder_providers.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'reminders_controller.g.dart';

/// Exposes the reminders list and handles CRUD + notification scheduling.
@riverpod
class RemindersController extends _$RemindersController {
  @override
  Future<List<Reminder>> build() =>
      ref.watch(reminderRepositoryProvider).allReminders();

  /// Adds a new reminder with the given [hour] and [minute], optionally tied
  /// to [mealSlotId].
  Future<void> addReminder({
    required int hour,
    required int minute,
    String? mealSlotId,
  }) async {
    final reminder = Reminder(
      id: const Uuid().v4(),
      hour: hour,
      minute: minute,
      enabled: true,
      mealSlotId: mealSlotId,
    );
    await _save(reminder);
    await _schedule(reminder);
  }

  /// Toggles the [enabled] state of the reminder identified by [id].
  Future<void> toggleReminder(String id) async {
    final reminders = await future;
    final index = reminders.indexWhere((r) => r.id == id);
    if (index == -1) return;
    final updated = reminders[index].copyWith(
      enabled: !reminders[index].enabled,
    );
    await _save(updated);
    if (updated.enabled) {
      await _schedule(updated);
    } else {
      await _cancel(updated.id);
    }
  }

  /// Deletes the reminder identified by [id].
  Future<void> deleteReminder(String id) async {
    final repository = ref.read(reminderRepositoryProvider);
    final notificationService = ref.read(notificationServiceProvider);
    await repository.deleteReminder(id);
    await notificationService.cancelNotification(id);
    state = AsyncData(
      (await repository.allReminders()).toList(),
    );
  }

  Future<void> _save(Reminder reminder) async {
    final repository = ref.read(reminderRepositoryProvider);
    await repository.saveReminder(reminder);
    state = AsyncData((await repository.allReminders()).toList());
  }

  Future<void> _schedule(Reminder reminder) async {
    final notificationService = ref.read(notificationServiceProvider);
    final granted = await notificationService.requestPermissions();
    if (granted) {
      await notificationService.scheduleNotification(reminder);
    }
  }

  Future<void> _cancel(String id) async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.cancelNotification(id);
  }
}
