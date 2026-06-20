import 'package:opendiet/features/reminders/domain/notification_service.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';

/// A [NotificationService] that records calls in memory.
class FakeNotificationService implements NotificationService {
  final List<String> scheduledIds = [];
  final List<String> cancelledIds = [];
  bool _permissionGranted = true;

  bool get permissionGranted => _permissionGranted;

  set permissionGranted(bool granted) {
    _permissionGranted = granted;
  }

  @override
  Future<bool> requestPermissions() async => _permissionGranted;

  @override
  Future<bool> checkPermissions() async => _permissionGranted;

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
