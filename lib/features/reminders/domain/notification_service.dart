import 'package:opendiet/features/reminders/domain/reminder.dart';

/// Abstracts platform-local notification scheduling (FR-021).
///
/// No remote/push service is used. All methods are no-ops when the platform
/// does not support local notifications.
abstract interface class NotificationService {
  /// Requests notification permission from the OS.
  /// Returns `true` when permission is granted.
  Future<bool> requestPermissions();

  /// Returns the current notification permission state.
  Future<bool> checkPermissions();

  /// Schedules a local notification for [reminder]'s time each day.
  Future<void> scheduleNotification(Reminder reminder);

  /// Cancels the notification identified by [id].
  Future<void> cancelNotification(String id);

  /// Cancels all scheduled notifications.
  Future<void> cancelAll();
}
