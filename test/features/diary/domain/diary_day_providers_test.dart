import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/diary/domain/diary_day_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  late FixedClock clock;

  setUp(() {
    clock = FixedClock(DateTime.utc(2026, 6, 20));
  });

  ProviderContainer createContainer() => ProviderContainer(
    overrides: [
      clockProvider.overrideWithValue(clock),
    ],
  );

  group('DiaryDay', () {
    test('initialises to the clock date', () {
      final container = createContainer();
      final day = container.read(diaryDayProvider);

      expect(day, DateTime.utc(2026, 6, 20));
    });

    test('nextDay advances by one calendar day', () {
      final container = createContainer();

      container.read(diaryDayProvider.notifier).nextDay();

      expect(container.read(diaryDayProvider), DateTime.utc(2026, 6, 21));
    });

    test('previousDay goes back by one calendar day', () {
      final container = createContainer();

      container.read(diaryDayProvider.notifier).previousDay();

      expect(container.read(diaryDayProvider), DateTime.utc(2026, 6, 19));
    });

    test('goToToday resets to the clock date after navigating away', () {
      final container = createContainer();
      container.read(diaryDayProvider.notifier).nextDay();
      container.read(diaryDayProvider.notifier).nextDay();

      container.read(diaryDayProvider.notifier).goToToday();

      expect(container.read(diaryDayProvider), DateTime.utc(2026, 6, 20));
    });

    test('multiple nextDay calls advance correctly', () {
      final container = createContainer();

      container.read(diaryDayProvider.notifier).nextDay();
      container.read(diaryDayProvider.notifier).nextDay();
      container.read(diaryDayProvider.notifier).nextDay();

      expect(container.read(diaryDayProvider), DateTime.utc(2026, 6, 23));
    });

    test('previousDay before month boundary works', () {
      clock = FixedClock(DateTime.utc(2026, 7));
      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(clock),
        ],
      );

      container.read(diaryDayProvider.notifier).previousDay();

      expect(container.read(diaryDayProvider), DateTime.utc(2026, 6, 30));
    });
  });
}
