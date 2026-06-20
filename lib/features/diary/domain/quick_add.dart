import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';

/// Builds ad-hoc "quick-add" diary entries (FR-031).
///
/// A quick-add entry is logged straight into a meal from just a name and an
/// energy value; it is not written to the foods catalog. The entry carries its
/// own label and nutrient snapshot, so it stands alone for totals and display.
abstract final class QuickAdd {
  /// An ad-hoc diary entry for [name] with [energyKcal] (plus any
  /// [additionalNutrients]), logged to [mealSlotId] on [day].
  static DiaryEntry entry({
    required String id,
    required String mealSlotId,
    required DateTime day,
    required DateTime loggedAt,
    required String name,
    required double energyKcal,
    Nutrients? additionalNutrients,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be blank');
    }
    if (!energyKcal.isFinite || energyKcal < 0) {
      throw ArgumentError.value(
        energyKcal,
        'energyKcal',
        'must be a finite, non-negative number',
      );
    }
    final nutrients = (additionalNutrients ?? Nutrients.empty).copyWith(
      energyKcal: energyKcal,
    );
    return DiaryEntry(
      id: id,
      day: day,
      mealSlotId: mealSlotId,
      referenceKind: DiaryReferenceKind.quickAdd,
      label: name.trim(),
      quantity: Quantity.servings(1),
      nutrients: nutrients,
      loggedAt: loggedAt,
    );
  }
}
