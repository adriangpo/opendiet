import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/features/reminders/data/drift_reminder_repository.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';

/// An in-memory Drift database for tests.
AppDatabase createTestDatabase() {
  final executor = NativeDatabase.memory();
  return AppDatabase(executor);
}

void main() {
  late AppDatabase database;
  late DriftReminderRepository repository;

  setUp(() async {
    database = createTestDatabase();
    repository = DriftReminderRepository(database);
    // Ensure tables are created
    await database.customStatement('PRAGMA foreign_keys = ON');
  });

  tearDown(() async {
    await database.close();
  });

  group('DriftReminderRepository', () {
    test('starts empty', () async {
      final reminders = await repository.allReminders();
      expect(reminders, isEmpty);
    });

    test('saves and retrieves a reminder', () async {
      final reminder = const Reminder(
        id: 'test-1',
        hour: 8,
        minute: 0,
        enabled: true,
      );

      await repository.saveReminder(reminder);
      final reminders = await repository.allReminders();

      expect(reminders.length, 1);
      expect(reminders.first.id, 'test-1');
      expect(reminders.first.hour, 8);
      expect(reminders.first.minute, 0);
      expect(reminders.first.enabled, isTrue);
      expect(reminders.first.mealSlotId, isNull);
    });

    test('saves and retrieves with mealSlotId', () async {
      // Insert the referenced meal slot first (FR-023 foreign key).
      await database
          .into(database.mealSlots)
          .insert(
            MealSlotsCompanion.insert(
              id: 'lunch-slot',
              name: 'Lunch',
              position: 2,
            ),
          );

      const reminder = Reminder(
        id: 'test-2',
        hour: 12,
        minute: 30,
        enabled: false,
        mealSlotId: 'lunch-slot',
      );

      await repository.saveReminder(reminder);
      final reminders = await repository.allReminders();

      expect(reminders.length, 1);
      expect(reminders.first.mealSlotId, 'lunch-slot');
      expect(reminders.first.enabled, isFalse);
    });

    test('updates an existing reminder', () async {
      const reminder = Reminder(
        id: 'test-3',
        hour: 8,
        minute: 0,
        enabled: true,
      );

      await repository.saveReminder(reminder);

      final updated = reminder.copyWith(enabled: false, hour: 9);
      await repository.saveReminder(updated);
      final reminders = await repository.allReminders();

      expect(reminders.length, 1);
      expect(reminders.first.enabled, isFalse);
      expect(reminders.first.hour, 9);
    });

    test('deletes a reminder', () async {
      const reminder = Reminder(
        id: 'test-4',
        hour: 20,
        minute: 0,
        enabled: true,
      );

      await repository.saveReminder(reminder);
      expect(await repository.allReminders(), hasLength(1));

      await repository.deleteReminder('test-4');
      expect(await repository.allReminders(), isEmpty);
    });

    test('delete is idempotent', () async {
      await repository.deleteReminder('non-existent');
      expect(await repository.allReminders(), isEmpty);
    });

    test('persists multiple reminders', () async {
      await repository.saveReminder(
        const Reminder(id: 'a', hour: 8, minute: 0, enabled: true),
      );
      await repository.saveReminder(
        const Reminder(id: 'b', hour: 12, minute: 0, enabled: true),
      );
      await repository.saveReminder(
        const Reminder(id: 'c', hour: 19, minute: 30, enabled: false),
      );

      final reminders = await repository.allReminders();
      expect(reminders.length, 3);
    });
  });
}
