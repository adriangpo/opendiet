import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';

part 'diary_entry.freezed.dart';
part 'diary_entry.g.dart';

/// Whether a diary entry references a food or a recipe.
enum DiaryReferenceKind { food, recipe }

/// A single logged item in the diary (FR-002, FR-003).
///
/// [nutrients] is the entry's own computed contribution, snapshotted at log
/// time so day totals stay stable and offline-computable (FR-004) even if the
/// source food is later edited or deleted. [label] snapshots the display name
/// for the same reason. [day] is the calendar day the entry belongs to.
@freezed
abstract class DiaryEntry with _$DiaryEntry {
  /// Creates a diary entry.
  const factory DiaryEntry({
    required String id,
    required DateTime day,
    required String mealSlotId,
    required DiaryReferenceKind referenceKind,
    required String referenceId,
    required String label,
    required Quantity quantity,
    required Nutrients nutrients,
    required DateTime loggedAt,
  }) = _DiaryEntry;

  /// Builds a diary entry from its JSON form.
  factory DiaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryFromJson(json);
}
