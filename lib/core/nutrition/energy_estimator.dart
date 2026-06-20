import 'package:opendiet/core/nutrition/nutrients.dart';

/// Estimates food energy (kcal) from its macronutrients.
///
/// Uses the energy conversion factors from EU Regulation 1169/2011, Annex XIV
/// (aligned with ANVISA/Codex): carbohydrates 4, protein 4, fat 9, fibre 2, and
/// alcohol 7 kcal/g. Carbohydrates are treated as available carbohydrate (fibre
/// excluded), so fibre contributes on top. The factors are held here once and
/// verified against the regulation in energy_estimator_test.dart (NFR-011).
abstract final class EnergyEstimator {
  /// kcal per gram of available carbohydrate.
  static const double carbohydrateKilocaloriesPerGram = 4;

  /// kcal per gram of protein.
  static const double proteinKilocaloriesPerGram = 4;

  /// kcal per gram of fat.
  static const double fatKilocaloriesPerGram = 9;

  /// kcal per gram of dietary fibre.
  static const double fibreKilocaloriesPerGram = 2;

  /// kcal per gram of alcohol (ethanol).
  static const double alcoholKilocaloriesPerGram = 7;

  /// The micronutrient key carrying ethanol mass in grams.
  static const String alcoholKey = 'alcohol_g';

  /// The energy implied by the macronutrients of [nutrients], or null when no
  /// contributing component is present (nothing to estimate from).
  static double? fromMacros(Nutrients nutrients) {
    final carbohydrates = nutrients.carbohydrates;
    final protein = nutrients.protein;
    final fat = nutrients.totalFat;
    final fibre = nutrients.dietaryFiber;
    final alcohol = nutrients.micronutrients[alcoholKey];

    final nothingToEstimate =
        carbohydrates == null &&
        protein == null &&
        fat == null &&
        fibre == null &&
        alcohol == null;
    if (nothingToEstimate) return null;

    return (carbohydrates ?? 0) * carbohydrateKilocaloriesPerGram +
        (protein ?? 0) * proteinKilocaloriesPerGram +
        (fat ?? 0) * fatKilocaloriesPerGram +
        (fibre ?? 0) * fibreKilocaloriesPerGram +
        (alcohol ?? 0) * alcoholKilocaloriesPerGram;
  }
}
