import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/foods/domain/food.dart';

/// Builds new custom-food drafts (FR-008).
///
/// Used both for a blank custom food and for promoting a quick-added diary
/// entry into a saved food (FR-031): pass the entry's label and nutrient
/// snapshot and let the editor complete the remaining fields.
abstract final class FoodDraft {
  /// A new custom food. [energyIsManual] should be true when [nutrients]
  /// already carries a user-entered energy value (e.g. a promoted quick-add),
  /// so the editor does not recompute it from the macros.
  static Food create({
    required String id,
    required DateTime now,
    String name = '',
    Nutrients nutrients = Nutrients.empty,
    NutrientBasis basis = NutrientBasis.perServing,
    bool energyIsManual = false,
  }) => Food(
    id: id,
    name: name,
    source: FoodSource.custom,
    basis: basis,
    nutrients: nutrients,
    energyIsManual: energyIsManual,
    createdAt: now,
    updatedAt: now,
  );
}
