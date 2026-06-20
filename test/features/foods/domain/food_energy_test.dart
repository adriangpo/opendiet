import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_energy.dart';

Food _food(Nutrients nutrients, {bool energyIsManual = false}) => Food(
  id: 'f',
  name: 'Food',
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: nutrients,
  energyIsManual: energyIsManual,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  test('a food defaults to automatic (not manual) energy', () {
    expect(_food(Nutrients.empty).energyIsManual, isFalse);
  });

  group('FoodEnergy.resolved', () {
    test('derives energy from the macros when automatic', () {
      final food = _food(const Nutrients(carbohydrates: 20, protein: 10));

      // 20*4 + 10*4 = 120.
      expect(
        FoodEnergy.resolved(food).nutrients.energyKcal,
        closeTo(120, 1e-9),
      );
    });

    test('overwrites a stale automatic energy value', () {
      final food = _food(const Nutrients(energyKcal: 5, protein: 10));

      expect(FoodEnergy.resolved(food).nutrients.energyKcal, closeTo(40, 1e-9));
    });

    test('leaves energy null when automatic but no macros are present', () {
      final food = _food(const Nutrients(sodiumMilligrams: 100));

      expect(FoodEnergy.resolved(food).nutrients.energyKcal, isNull);
    });

    test('never touches energy once the user owns it', () {
      final food = _food(
        const Nutrients(energyKcal: 250, carbohydrates: 20, protein: 10),
        energyIsManual: true,
      );

      // Macros imply 120, but the manual 250 must stand.
      expect(FoodEnergy.resolved(food).nutrients.energyKcal, 250);
    });
  });

  group('FoodEnergy.withManualEnergy', () {
    test('takes ownership of the energy value and stops auto-calc', () {
      final food = _food(const Nutrients(carbohydrates: 20));

      final owned = FoodEnergy.withManualEnergy(food, 300);

      expect(owned.energyIsManual, isTrue);
      expect(owned.nutrients.energyKcal, 300);
      // A later resolve must not recompute it back to the macro estimate.
      expect(FoodEnergy.resolved(owned).nutrients.energyKcal, 300);
    });
  });

  group('FoodEnergy.withAutomaticEnergy', () {
    test('returns ownership to auto-calc and recomputes from macros', () {
      final manual = _food(
        const Nutrients(energyKcal: 300, carbohydrates: 20),
        energyIsManual: true,
      );

      final auto = FoodEnergy.withAutomaticEnergy(manual);

      expect(auto.energyIsManual, isFalse);
      expect(auto.nutrients.energyKcal, closeTo(80, 1e-9));
    });
  });
}
