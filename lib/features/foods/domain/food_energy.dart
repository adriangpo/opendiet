import 'package:opendiet/core/nutrition/energy_estimator.dart';
import 'package:opendiet/features/foods/domain/food.dart';

/// Applies the energy auto-calculation rule to a [Food] (FR-008, FR-028).
///
/// Energy is derived from the macros while it is automatic; the moment the user
/// types an energy value it becomes manual and authoritative, and is never
/// recomputed until they hand ownership back. The food editor calls these as
/// the user edits macros or the energy field.
abstract final class FoodEnergy {
  /// [food] with energy derived from its macros, unless the user owns energy.
  static Food resolved(Food food) {
    if (food.energyIsManual) return food;
    return food.copyWith(
      nutrients: food.nutrients.copyWith(
        energyKcal: EnergyEstimator.fromMacros(food.nutrients),
      ),
    );
  }

  /// [food] with the user-entered [energyKcal] taken as authoritative; auto
  /// calculation stops until ownership is handed back.
  static Food withManualEnergy(Food food, double? energyKcal) => food.copyWith(
    energyIsManual: true,
    nutrients: food.nutrients.copyWith(energyKcal: energyKcal),
  );

  /// [food] with energy returned to automatic and recomputed from the macros.
  static Food withAutomaticEnergy(Food food) =>
      resolved(food.copyWith(energyIsManual: false));
}
