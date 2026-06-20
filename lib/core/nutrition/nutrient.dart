/// The canonical unit a nutrient amount is stored in.
enum NutrientUnit { kilocalorie, gram, milligram }

/// The ten ANVISA-mandatory nutrients, in label-declaration order.
///
/// The set and its order are the ANVISA IN 75/2020 contract documented in
/// agent_docs/brazilian_nutrition.md; this enum is the single in-code
/// representation of it. Micronutrients are an open set held separately on the
/// Nutrients profile and are not enumerated here.
enum Nutrient {
  energy(NutrientUnit.kilocalorie),
  carbohydrates(NutrientUnit.gram),
  totalSugars(NutrientUnit.gram),
  addedSugars(NutrientUnit.gram),
  protein(NutrientUnit.gram),
  totalFat(NutrientUnit.gram),
  saturatedFat(NutrientUnit.gram),
  transFat(NutrientUnit.gram),
  dietaryFiber(NutrientUnit.gram),
  sodium(NutrientUnit.milligram);

  const Nutrient(this.unit);

  /// The unit this nutrient's amount is expressed in.
  final NutrientUnit unit;
}
