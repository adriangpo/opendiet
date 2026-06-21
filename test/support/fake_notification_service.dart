import 'package:opendiet/features/reminders/domain/notification_service.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';

/// A [NotificationService] that records calls in memory.
class FakeNotificationService implements NotificationService {
  final List<String> scheduledIds = [];
  final List<String> cancelledIds = [];

  bool permissionGranted = true;

  @override
  Future<bool> requestPermissions() async => permissionGranted;

  @override
  Future<bool> checkPermissions() async => permissionGranted;

  @override
  Future<void> scheduleNotification(Reminder reminder) async {
    scheduledIds.add(reminder.id);
  }

  @override
  Future<void> cancelNotification(String id) async {
    cancelledIds.add(id);
  }

  @override
  Future<void> cancelAll() async {
    scheduledIds.clear();
    cancelledIds.clear();
  }
}
