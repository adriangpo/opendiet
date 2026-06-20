import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/time/clock.dart';

void main() {
  group('SystemClock', () {
    test('returns a time at or after the wall clock when called', () {
      const clock = SystemClock();
      final before = DateTime.now();
      final now = clock.now();
      final after = DateTime.now();

      expect(now.isBefore(before), isFalse);
      expect(now.isAfter(after), isFalse);
    });
  });

  group('FixedClock', () {
    test('returns the instant it was constructed with', () {
      final instant = DateTime.utc(2026, 6, 19, 8);
      final clock = FixedClock(instant);

      expect(clock.now(), instant);
    });

    test('reports the same instant on repeated reads', () {
      final clock = FixedClock(DateTime.utc(2026));

      expect(clock.now(), clock.now());
    });

    test('advance moves the instant forward by the given duration', () {
      final clock = FixedClock(DateTime.utc(2026, 6, 19, 8))
        ..advance(const Duration(hours: 2, minutes: 30));

      expect(clock.now(), DateTime.utc(2026, 6, 19, 10, 30));
    });
  });
}
