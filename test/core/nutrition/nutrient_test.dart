import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';

void main() {
  group('Nutrient', () {
    test('lists the ten ANVISA-mandatory nutrients in declaration order', () {
      // Order follows ANVISA IN 75/2020 (see agent_docs/brazilian_nutrition.md).
      expect(Nutrient.values, <Nutrient>[
        Nutrient.energy,
        Nutrient.carbohydrates,
        Nutrient.totalSugars,
        Nutrient.addedSugars,
        Nutrient.protein,
        Nutrient.totalFat,
        Nutrient.saturatedFat,
        Nutrient.transFat,
        Nutrient.dietaryFiber,
        Nutrient.sodium,
      ]);
    });

    test('energy is measured in kilocalories', () {
      expect(Nutrient.energy.unit, NutrientUnit.kilocalorie);
    });

    test('sodium is measured in milligrams', () {
      expect(Nutrient.sodium.unit, NutrientUnit.milligram);
    });

    test('macronutrients are measured in grams', () {
      for (final nutrient in [
        Nutrient.carbohydrates,
        Nutrient.totalSugars,
        Nutrient.addedSugars,
        Nutrient.protein,
        Nutrient.totalFat,
        Nutrient.saturatedFat,
        Nutrient.transFat,
        Nutrient.dietaryFiber,
      ]) {
        expect(nutrient.unit, NutrientUnit.gram, reason: nutrient.name);
      }
    });
  });
}
