import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;

/// Maps an Open Food Facts [off.Product] to the app's [Food] model.
///
/// Nutrient keys follow the OFF API contract (see
/// https://openfoodfacts.github.io/openfoodfacts-server/api/).
/// Never restate field meanings or limits in code comments (AGENTS.md).
abstract final class OffProductMapper {
  /// Converts [product] to a [Food] with source [FoodSource.openFoodFacts].
  ///
  /// [id] is a fresh app-level identifier; [now] is the creation timestamp.
  /// Nutrients that the OFF product does not provide are left absent (not
  /// zero) per FR-025.
  static Food toFood({
    required off.Product product,
    required String id,
    required DateTime now,
  }) {
    final nutriments = product.nutriments;
    final perSize = _resolvePerSize(product);

    return Food(
      id: id,
      name: product.productName ?? product.barcode ?? 'Unknown',
      source: FoodSource.openFoodFacts,
      basis: _basis(product),
      nutrients: Nutrients(
        energyKcal: nutriments?.getValue(off.Nutrient.energyKCal, perSize),
        carbohydrates: nutriments?.getValue(
          off.Nutrient.carbohydrates,
          perSize,
        ),
        totalSugars: nutriments?.getValue(off.Nutrient.sugars, perSize),
        addedSugars: _addedSugars(nutriments, perSize),
        protein: nutriments?.getValue(off.Nutrient.proteins, perSize),
        totalFat: nutriments?.getValue(off.Nutrient.fat, perSize),
        saturatedFat: nutriments?.getValue(off.Nutrient.saturatedFat, perSize),
        transFat: nutriments?.getValue(off.Nutrient.transFat, perSize),
        dietaryFiber: nutriments?.getValue(off.Nutrient.fiber, perSize),
        sodiumMilligrams: _sodiumMilligrams(nutriments, perSize),
      ),
      brand: product.brands,
      barcode: product.barcode,
      servingSizeMetric: _servingSizeMetric(product),
      servingUnit: _servingUnit(product),
      createdAt: now,
      updatedAt: now,
    );
  }

  static off.PerSize _resolvePerSize(off.Product product) {
    final dataPer = product.nutrimentDataPer;
    if (dataPer == '100g' || dataPer == '100 ml') {
      return off.PerSize.oneHundredGrams;
    }
    return off.PerSize.oneHundredGrams;
  }

  static NutrientBasis _basis(off.Product product) {
    final dataPer = product.nutrimentDataPer;
    if (dataPer == '100 ml') return NutrientBasis.per100ml;
    if (dataPer == '100g') return NutrientBasis.per100g;
    final isLiquid = product.quantity?.toLowerCase().contains('ml') ?? false;
    if (isLiquid) return NutrientBasis.per100ml;
    return NutrientBasis.per100g;
  }

  static double? _addedSugars(off.Nutriments? nutriments, off.PerSize perSize) {
    if (nutriments == null) return null;
    final added = nutriments.getValue(off.Nutrient.addedSugars, perSize);
    if (added != null && added > 0) return added;
    return null;
  }

  static double? _sodiumMilligrams(
    off.Nutriments? nutriments,
    off.PerSize perSize,
  ) {
    if (nutriments == null) return null;
    final grams = nutriments.getValue(off.Nutrient.sodium, perSize);
    return grams == null ? null : grams * 1000;
  }

  static double? _servingSizeMetric(off.Product product) {
    final quantity = product.servingQuantity;
    if (quantity != null && quantity > 0) return quantity;
    final size = product.servingSize;
    if (size == null) return null;
    final normalized = size.replaceAll(',', '.');
    final parsed = double.tryParse(
      normalized.replaceAll(RegExp('[^0-9.]'), ''),
    );
    if (parsed != null && parsed > 0) return parsed;
    return null;
  }

  static ServingUnit? _servingUnit(off.Product product) {
    final size = product.servingSize?.toLowerCase() ?? '';
    if (size.contains('ml')) return ServingUnit.milliliter;
    if (size.contains('g')) return ServingUnit.gram;
    return null;
  }
}
