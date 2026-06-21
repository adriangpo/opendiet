import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/features/reminders/data/reminder_providers.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';
import 'package:opendiet/features/reminders/presentation/reminders_controller.dart';

import '../../../support/fake_notification_service.dart';
import '../../../support/fake_reminder_repository.dart';

void main() {
  ProviderContainer container({
    required FakeReminderRepository repository,
    required FakeNotificationService notificationService,
    IdGenerator? idGenerator,
  }) {
    final result = ProviderContainer(
      overrides: [
        reminderRepositoryProvider.overrideWithValue(repository),
        notificationServiceProvider.overrideWithValue(notificationService),
        if (idGenerator != null)
          idGeneratorProvider.overrideWithValue(idGenerator),
      ],
    );
    addTearDown(result.dispose);
    return result;
  }

  group('RemindersController', () {
    test('adds a reminder with the injected sortable id generator', () async {
      final repository = FakeReminderRepository();
      final notificationService = FakeNotificationService();
      final controller = container(
        repository: repository,
        notificationService: notificationService,
        idGenerator: _FixedIdGenerator('reminder-001'),
      ).read(remindersControllerProvider.notifier);

      await controller.addReminder(hour: 8, minute: 0);

      final reminders = await repository.allReminders();
      expect(reminders.single.id, 'reminder-001');
      expect(notificationService.scheduledIds, ['reminder-001']);
    });

    test('edits an enabled reminder time and reschedules it', () async {
      final repository = FakeReminderRepository();
      await repository.saveReminder(
        const Reminder(id: 'breakfast', hour: 8, minute: 0, enabled: true),
      );
      final notificationService = FakeNotificationService();
      final controller = container(
        repository: repository,
        notificationService: notificationService,
      ).read(remindersControllerProvider.notifier);

      await controller.updateReminderTime('breakfast', hour: 9, minute: 30);

      final reminders = await repository.allReminders();
      expect(reminders.single.hour, 9);
      expect(reminders.single.minute, 30);
      expect(notificationService.cancelledIds, ['breakfast']);
      expect(notificationService.scheduledIds, ['breakfast']);
    });

    test('edits a disabled reminder time without scheduling it', () async {
      final repository = FakeReminderRepository();
      await repository.saveReminder(
        const Reminder(id: 'dinner', hour: 19, minute: 0, enabled: false),
      );
      final notificationService = FakeNotificationService();
      final controller = container(
        repository: repository,
        notificationService: notificationService,
      ).read(remindersControllerProvider.notifier);

      await controller.updateReminderTime('dinner', hour: 20, minute: 15);

      final reminders = await repository.allReminders();
      expect(reminders.single.hour, 20);
      expect(reminders.single.minute, 15);
      expect(notificationService.cancelledIds, ['dinner']);
      expect(notificationService.scheduledIds, isEmpty);
    });
  });
}

class _FixedIdGenerator implements IdGenerator {
  _FixedIdGenerator(this._id);

  final String _id;

  @override
  String newId() => _id;
}
