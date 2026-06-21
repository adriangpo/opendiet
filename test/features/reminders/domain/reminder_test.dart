import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/reminders/domain/reminder.dart';

void main() {
  group('Reminder entity', () {
    test('creates with all required fields', () {
      const reminder = Reminder(id: 'id-1', hour: 8, minute: 0, enabled: true);

      expect(reminder.id, 'id-1');
      expect(reminder.hour, 8);
      expect(reminder.minute, 0);
      expect(reminder.enabled, isTrue);
      expect(reminder.mealSlotId, isNull);
    });

    test('creates with optional mealSlotId', () {
      const reminder = Reminder(
        id: 'id-2',
        hour: 12,
        minute: 30,
        enabled: false,
        mealSlotId: 'lunch',
      );

      expect(reminder.mealSlotId, 'lunch');
      expect(reminder.enabled, isFalse);
    });

    test('round-trips through JSON', () {
      const reminder = Reminder(
        id: 'json-1',
        hour: 18,
        minute: 45,
        enabled: true,
        mealSlotId: 'dinner',
      );

      final json = reminder.toJson();
      final restored = Reminder.fromJson(json);

      expect(restored, reminder);
    });

    test('round-trips through JSON without mealSlotId', () {
      const reminder = Reminder(
        id: 'json-2',
        hour: 7,
        minute: 0,
        enabled: false,
      );

      final json = reminder.toJson();
      final restored = Reminder.fromJson(json);

      expect(restored, reminder);
    });

    test('equality uses value semantics', () {
      const a = Reminder(id: '1', hour: 8, minute: 0, enabled: true);
      const b = Reminder(id: '1', hour: 8, minute: 0, enabled: true);
      const c = Reminder(id: '2', hour: 8, minute: 0, enabled: true);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('toString includes fields', () {
      const reminder = Reminder(id: 't', hour: 9, minute: 15, enabled: true);
      expect(reminder.toString(), contains('hour: 9'));
      expect(reminder.toString(), contains('minute: 15'));
    });
  });
}
