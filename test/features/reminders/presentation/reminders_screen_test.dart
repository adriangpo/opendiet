import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/reminders/data/reminder_providers.dart';
import 'package:opendiet/features/reminders/domain/notification_service.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';
import 'package:opendiet/features/reminders/domain/reminder_repository.dart';
import 'package:opendiet/features/reminders/presentation/reminders_screen.dart';
import 'package:opendiet/l10n/app_localizations.dart';

import '../../../support/fake_notification_service.dart';
import '../../../support/fake_reminder_repository.dart';

/// Pumps the [RemindersScreen] in a test harness.
Future<void> pumpRemindersScreen(
  WidgetTester tester, {
  ReminderRepository? repository,
  NotificationService? notificationService,
}) async {
  final repo = repository ?? FakeReminderRepository();
  final notif = notificationService ?? FakeNotificationService();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        reminderRepositoryProvider.overrideWithValue(repo),
        notificationServiceProvider.overrideWithValue(notif),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RemindersScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  group('RemindersScreen (S-15)', () {
    testWidgets('shows empty state when no reminders exist', (tester) async {
      await pumpRemindersScreen(tester);

      expect(find.text('Reminders'), findsOneWidget);
      expect(find.text('No reminders yet.'), findsOneWidget);
    });

    testWidgets('shows list of saved reminders', (tester) async {
      final repository = FakeReminderRepository();
      await repository.saveReminder(
        const Reminder(id: '1', hour: 8, minute: 0, enabled: true),
      );
      await repository.saveReminder(
        const Reminder(id: '2', hour: 13, minute: 0, enabled: false),
      );

      await pumpRemindersScreen(tester, repository: repository);

      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('13:00'), findsOneWidget);
    });

    testWidgets('shows an edit action for saved reminders', (tester) async {
      final repository = FakeReminderRepository();
      await repository.saveReminder(
        const Reminder(id: '1', hour: 8, minute: 0, enabled: true),
      );

      await pumpRemindersScreen(tester, repository: repository);

      expect(find.byKey(const Key('reminder-edit-1')), findsOneWidget);
    });

    testWidgets('toggling a reminder enables/disables it', (tester) async {
      final repository = FakeReminderRepository();
      await repository.saveReminder(
        const Reminder(id: '1', hour: 8, minute: 0, enabled: true),
      );

      await pumpRemindersScreen(tester, repository: repository);

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pump();
      await tester.pump();

      final reminders = await repository.allReminders();
      expect(reminders.single.enabled, isFalse);
    });

    testWidgets('shows add reminder button', (tester) async {
      await pumpRemindersScreen(tester);

      expect(find.text('+ Add reminder'), findsOneWidget);
    });

    testWidgets('removing a reminder shows confirmation then deletes', (
      tester,
    ) async {
      final repository = FakeReminderRepository();
      await repository.saveReminder(
        const Reminder(id: '1', hour: 8, minute: 0, enabled: true),
      );
      await repository.saveReminder(
        const Reminder(id: '2', hour: 13, minute: 0, enabled: true),
      );

      await pumpRemindersScreen(tester, repository: repository);

      final deleteButtons = find.byIcon(Boxicons.bx_trash);
      expect(deleteButtons, findsNWidgets(2));

      await tester.tap(deleteButtons.first);
      await tester.pump();
      await tester.pump();

      expect(find.text('Remove reminder?'), findsOneWidget);
      await tester.tap(find.text('Remove'));
      await tester.pump();
      await tester.pump();

      final reminders = await repository.allReminders();
      expect(reminders, hasLength(1));
    });
  });
}
