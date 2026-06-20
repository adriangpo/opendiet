import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';

/// Aggregates diary entries into daily nutrient totals (FR-004).
///
/// Each entry already carries its computed nutrient snapshot, so totals are a
/// pure sum computed entirely on-device with no network dependency.
abstract final class DiaryTotals {
  /// The summed nutrition of [entries].
  static Nutrients forEntries(Iterable<DiaryEntry> entries) =>
      Nutrients.sum(entries.map((entry) => entry.nutrients));

  /// The summed nutrition of the [entries] that fall on [day]'s calendar date.
  static Nutrients forDay(Iterable<DiaryEntry> entries, DateTime day) =>
      forEntries(entries.where((entry) => _isSameDate(entry.day, day)));

  static bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Compares a day's totals against the user's daily target (FR-022).
abstract final class DailyTargetComparison {
  /// Amount of [nutrient] left before reaching [target], or null when the
  /// target sets no value for it. Negative means consumption is over target;
  /// an absent total counts as zero consumed.
  static double? remaining(
    Nutrients totals,
    Nutrients? target,
    Nutrient nutrient,
  ) {
    final goal = target?.amountOf(nutrient);
    if (goal == null) return null;
    return goal - (totals.amountOf(nutrient) ?? 0);
  }
}
