import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:opendiet/features/reminders/domain/notification_service.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// A [NotificationService] that uses [FlutterLocalNotificationsPlugin] to
/// schedule on-device reminders (FR-021).
class FlutterNotificationService implements NotificationService {
  /// Creates the service.
  FlutterNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'opendiet_reminders';
  static const _channelName = 'Mealtime reminders';
  static const _channelDescription =
      'Reminds you to log your meals at configured times';

  bool _initialized = false;

  /// Initializes the plugin with default settings.
  Future<bool?> initialize() async {
    if (_initialized) return true;
    tz_data.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    final result = await _plugin.initialize(settings: settings);
    _initialized = true;
    return result;
  }

  @override
  Future<bool> requestPermissions() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final result = await android.requestNotificationsPermission();
      return result ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final result = await ios.requestPermissions(
        alert: true,
        badge: false,
        sound: true,
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Future<bool> checkPermissions() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final result = await android.areNotificationsEnabled();
      return result ?? false;
    }
    return true;
  }

  @override
  Future<void> scheduleNotification(Reminder reminder) async {
    await initialize();
    if (!reminder.enabled) return;

    final now = DateTime.now();
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminder.hour,
      reminder.minute,
    );

    // If the time has already passed today, schedule for tomorrow.
    final adjustedDate = scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id: reminder.id.hashCode,
      scheduledDate: adjustedDate,
      title: _channelName,
      body: 'Time to log your meal!',
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelNotification(String id) async {
    await _plugin.cancel(id: id.hashCode);
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
