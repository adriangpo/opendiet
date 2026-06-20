import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/energy_estimator.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';

void main() {
  // NFR-011: the energy conversion factors are verified here against their
  // source regulation (EU Reg 1169/2011, Annex XIV) and live in one place.
  group('conversion factors (kcal per gram)', () {
    test('match EU Reg 1169/2011 Annex XIV', () {
      expect(EnergyEstimator.carbohydrateKilocaloriesPerGram, 4);
      expect(EnergyEstimator.proteinKilocaloriesPerGram, 4);
      expect(EnergyEstimator.fatKilocaloriesPerGram, 9);
      expect(EnergyEstimator.fibreKilocaloriesPerGram, 2);
      expect(EnergyEstimator.alcoholKilocaloriesPerGram, 7);
    });
  });

  group('EnergyEstimator.fromMacros', () {
    test('applies 4 kcal/g to available carbohydrates', () {
      expect(
        EnergyEstimator.fromMacros(const Nutrients(carbohydrates: 10)),
        closeTo(40, 1e-9),
      );
    });

    test('applies 4 kcal/g to protein', () {
      expect(
        EnergyEstimator.fromMacros(const Nutrients(protein: 10)),
        closeTo(40, 1e-9),
      );
    });

    test('applies 9 kcal/g to fat', () {
      expect(
        EnergyEstimator.fromMacros(const Nutrients(totalFat: 10)),
        closeTo(90, 1e-9),
      );
    });

    test('applies 2 kcal/g to dietary fibre on top of carbohydrates', () {
      // Carbs are available carbs (exclude fibre), so fibre adds separately.
      expect(
        EnergyEstimator.fromMacros(
          const Nutrients(carbohydrates: 10, dietaryFiber: 5),
        ),
        closeTo(40 + 10, 1e-9),
      );
    });

    test('applies 7 kcal/g to alcohol carried as a micronutrient', () {
      expect(
        EnergyEstimator.fromMacros(
          const Nutrients(micronutrients: {EnergyEstimator.alcoholKey: 10}),
        ),
        closeTo(70, 1e-9),
      );
    });

    test('sums every contributing component', () {
      const nutrients = Nutrients(
        carbohydrates: 20,
        protein: 10,
        totalFat: 5,
        dietaryFiber: 3,
      );

      // 20*4 + 10*4 + 5*9 + 3*2 = 80 + 40 + 45 + 6.
      expect(EnergyEstimator.fromMacros(nutrients), closeTo(171, 1e-9));
    });

    test('treats absent components as contributing nothing', () {
      expect(
        EnergyEstimator.fromMacros(const Nutrients(protein: 10)),
        closeTo(40, 1e-9),
      );
    });

    test('returns null when no contributing component is present', () {
      // Energy itself and non-energy micronutrients do not enable an estimate.
      expect(
        EnergyEstimator.fromMacros(
          const Nutrients(energyKcal: 999, sodiumMilligrams: 200),
        ),
        isNull,
      );
      expect(EnergyEstimator.fromMacros(Nutrients.empty), isNull);
    });
  });
}
