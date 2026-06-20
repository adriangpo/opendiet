import 'package:opendiet/core/time/time_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_day_providers.g.dart';

/// The calendar day currently shown on the diary (FR-018).
///
/// Initialises to today's date according to the injected clock, so tests stay
/// deterministic. Changes to this provider cause the diary to reload entries.
@Riverpod(keepAlive: true)
class DiaryDay extends _$DiaryDay {
  @override
  DateTime build() => ref.watch(clockProvider).now();

  /// Moves to the next calendar day.
  void nextDay() => state = _addDays(state, 1);

  /// Moves to the previous calendar day.
  void previousDay() => state = _addDays(state, -1);

  /// Resets to today's date.
  void goToToday() => state = ref.read(clockProvider).now();
}

/// Returns [date] plus [days] calendar days (may be negative).
DateTime _addDays(DateTime date, int days) =>
    DateTime.utc(date.year, date.month, date.day + days);
