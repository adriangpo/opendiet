import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';

part 'food.freezed.dart';
part 'food.g.dart';

/// Where a food came from.
///
/// All three sources feed the same [Food] model via their repositories
/// (see AGENTS.md); the rest of the app never branches on a concrete source.
enum FoodSource { custom, openFoodFacts, imported }

/// The basis a food's nutrient values are expressed on.
enum NutrientBasis { per100g, per100ml, perServing }

/// A food the user can log: custom, imported, or sourced from Open Food Facts.
///
/// Nutrient values are stored on [basis]; [servingSizeMetric] is one serving in
/// canonical metric (grams or milliliters) and is required to convert between a
/// per-100 and a per-serving view (see the foods nutrition use case).
///
/// [energyIsManual] records whether the user owns the energy value: while
/// false, energy is derived from the macros (see FoodEnergy); once the user
/// types an energy value it becomes true and is no longer recomputed.
@freezed
abstract class Food with _$Food {
  /// Creates a food.
  const factory Food({
    required String id,
    required String name,
    required FoodSource source,
    required NutrientBasis basis,
    required Nutrients nutrients,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? brand,
    String? barcode,
    double? servingSizeMetric,
    ServingUnit? servingUnit,
    String? householdMeasure,
    @Default(false) bool energyIsManual,
  }) = _Food;

  const Food._();

  /// Builds a food from its JSON form.
  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
}
