import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:opendiet/core/database/database_providers.dart';
import 'package:opendiet/features/reminders/data/drift_reminder_repository.dart';
import 'package:opendiet/features/reminders/data/flutter_notification_service.dart';
import 'package:opendiet/features/reminders/domain/notification_service.dart';
import 'package:opendiet/features/reminders/domain/reminder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_providers.g.dart';

/// The reminder repository, backed by the on-device database.
@Riverpod(keepAlive: true)
ReminderRepository reminderRepository(Ref ref) =>
    DriftReminderRepository(ref.watch(appDatabaseProvider));

/// The platform notification service.
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  final service = FlutterNotificationService(FlutterLocalNotificationsPlugin());
  ref.onDispose(service.cancelAll);
  return service;
}
