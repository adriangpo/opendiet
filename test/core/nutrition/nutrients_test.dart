import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';

void main() {
  group('Nutrients defaults', () {
    test('empty equals a bare profile with every field absent', () {
      // Deliberately builds the bare value to prove the named const matches it.
      // ignore: use_named_constants
      const bare = Nutrients();

      expect(Nutrients.empty, bare);
      for (final nutrient in Nutrient.values) {
        expect(bare.amountOf(nutrient), isNull, reason: nutrient.name);
      }
      expect(bare.micronutrients, isEmpty);
    });
  });

  group('amountOf', () {
    test('reads each mandatory nutrient field', () {
      const nutrients = Nutrients(
        energyKcal: 100,
        carbohydrates: 1,
        totalSugars: 2,
        addedSugars: 3,
        protein: 4,
        totalFat: 5,
        saturatedFat: 6,
        transFat: 7,
        dietaryFiber: 8,
        sodiumMilligrams: 9,
      );

      expect(nutrients.amountOf(Nutrient.energy), 100);
      expect(nutrients.amountOf(Nutrient.carbohydrates), 1);
      expect(nutrients.amountOf(Nutrient.totalSugars), 2);
      expect(nutrients.amountOf(Nutrient.addedSugars), 3);
      expect(nutrients.amountOf(Nutrient.protein), 4);
      expect(nutrients.amountOf(Nutrient.totalFat), 5);
      expect(nutrients.amountOf(Nutrient.saturatedFat), 6);
      expect(nutrients.amountOf(Nutrient.transFat), 7);
      expect(nutrients.amountOf(Nutrient.dietaryFiber), 8);
      expect(nutrients.amountOf(Nutrient.sodium), 9);
    });
  });

  group('scale', () {
    test('multiplies present values and leaves absent ones absent', () {
      const nutrients = Nutrients(
        energyKcal: 100,
        protein: 5,
        micronutrients: {'calcium_mg': 20},
      );

      final scaled = nutrients.scale(2.5);

      expect(scaled.energyKcal, 250);
      expect(scaled.protein, closeTo(12.5, 1e-9));
      expect(scaled.micronutrients['calcium_mg'], 50);
      expect(scaled.carbohydrates, isNull);
    });

    test(
      'scaling by zero yields zero for present values, absent stays absent',
      () {
        const nutrients = Nutrients(energyKcal: 100, protein: 5);

        final scaled = nutrients.scale(0);

        expect(scaled.energyKcal, 0);
        expect(scaled.protein, 0);
        expect(scaled.carbohydrates, isNull);
      },
    );

    test('rejects a negative factor', () {
      expect(() => Nutrients.empty.scale(-1), throwsArgumentError);
    });

    test('rejects a non-finite factor', () {
      expect(() => Nutrients.empty.scale(double.nan), throwsArgumentError);
      expect(() => Nutrients.empty.scale(double.infinity), throwsArgumentError);
    });
  });

  group('operator +', () {
    test('adds two present values', () {
      const a = Nutrients(energyKcal: 100);
      const b = Nutrients(energyKcal: 50);

      expect((a + b).energyKcal, 150);
    });

    test('a present value plus an absent one keeps the present value', () {
      const a = Nutrients(protein: 10);
      const b = Nutrients.empty;

      expect((a + b).protein, 10);
      expect((b + a).protein, 10);
    });

    test('two absent values stay absent (never coerced to zero)', () {
      const a = Nutrients(energyKcal: 100);
      const b = Nutrients(energyKcal: 50);

      // carbohydrates is absent in both, so the total must remain absent.
      expect((a + b).carbohydrates, isNull);
    });

    test('unions micronutrient keys and sums overlaps', () {
      const a = Nutrients(micronutrients: {'calcium_mg': 20, 'iron_mg': 1});
      const b = Nutrients(micronutrients: {'calcium_mg': 5, 'zinc_mg': 2});

      final summed = (a + b).micronutrients;

      expect(summed['calcium_mg'], 25);
      expect(summed['iron_mg'], 1);
      expect(summed['zinc_mg'], 2);
    });
  });

  group('sum', () {
    test('an empty iterable sums to all-absent', () {
      expect(Nutrients.sum(const []), Nutrients.empty);
    });

    test('a single element sums to itself', () {
      const only = Nutrients(energyKcal: 42, micronutrients: {'iron_mg': 3});

      expect(Nutrients.sum(const [only]), only);
    });

    test('folds several entries field by field', () {
      const entries = [
        Nutrients(energyKcal: 100, protein: 5),
        Nutrients(energyKcal: 200, totalFat: 3),
        Nutrients(energyKcal: 50, protein: 1),
      ];

      final total = Nutrients.sum(entries);

      expect(total.energyKcal, 350);
      expect(total.protein, 6);
      expect(total.totalFat, 3);
      expect(total.carbohydrates, isNull);
    });
  });

  group('json', () {
    test('round-trips through json including micronutrients', () {
      const nutrients = Nutrients(
        energyKcal: 123.4,
        sodiumMilligrams: 200,
        micronutrients: {'vitamin_c_mg': 12},
      );

      expect(Nutrients.fromJson(nutrients.toJson()), nutrients);
    });

    test('absent fields survive a json round-trip as null, not zero', () {
      const nutrients = Nutrients(energyKcal: 100);

      final restored = Nutrients.fromJson(nutrients.toJson());

      expect(restored.protein, isNull);
      expect(restored.transFat, isNull);
    });
  });
}
