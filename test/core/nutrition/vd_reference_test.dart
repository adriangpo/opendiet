import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';

void main() {
  // NFR-011: each reference set is verified here against its source regulation.
  // The numbers below are quoted from the cited regulations and are the single
  // authority the implementation table is checked against.

  group('Brazil reference set (ANVISA IN 75/2020, Annex II VDR)', () {
    // Source: ANVISA RDC 429/2020 + IN 75/2020, Anexo II
    // (https://www.gov.br/anvisa -> rotulagem nutricional).
    final set = VdReference.forRegion(VdRegion.brazil);

    test('mandatory nutrients with a VD match the regulation', () {
      expect(set.referenceFor(Nutrient.energy), 2000);
      expect(set.referenceFor(Nutrient.carbohydrates), 300);
      expect(set.referenceFor(Nutrient.addedSugars), 50);
      expect(set.referenceFor(Nutrient.protein), 50);
      expect(set.referenceFor(Nutrient.totalFat), 65);
      expect(set.referenceFor(Nutrient.saturatedFat), 20);
      expect(set.referenceFor(Nutrient.dietaryFiber), 25);
      expect(set.referenceFor(Nutrient.sodium), 2000);
    });

    test('nutrients without a VD have no reference', () {
      expect(set.referenceFor(Nutrient.totalSugars), isNull);
      expect(set.referenceFor(Nutrient.transFat), isNull);
    });
  });

  group('US reference set (FDA Daily Values, 2016 label)', () {
    // Source: 21 CFR 101.9 Daily Values (2016 Nutrition Facts label update).
    final set = VdReference.forRegion(VdRegion.unitedStates);

    test('daily values match the regulation', () {
      expect(set.referenceFor(Nutrient.energy), 2000);
      expect(set.referenceFor(Nutrient.carbohydrates), 275);
      expect(set.referenceFor(Nutrient.addedSugars), 50);
      expect(set.referenceFor(Nutrient.protein), 50);
      expect(set.referenceFor(Nutrient.totalFat), 78);
      expect(set.referenceFor(Nutrient.saturatedFat), 20);
      expect(set.referenceFor(Nutrient.dietaryFiber), 28);
      expect(set.referenceFor(Nutrient.sodium), 2300);
    });

    test('total sugars and trans fat have no daily value', () {
      expect(set.referenceFor(Nutrient.totalSugars), isNull);
      expect(set.referenceFor(Nutrient.transFat), isNull);
    });
  });

  group('EU reference set (Reg 1169/2011, Annex XIII Part B)', () {
    // Source: Regulation (EU) No 1169/2011, Annex XIII, Part B (Reference
    // Intakes). Salt 6 g is held as sodium 2400 mg (salt / 2.5).
    final set = VdReference.forRegion(VdRegion.europeanUnion);

    test('reference intakes match the regulation', () {
      expect(set.referenceFor(Nutrient.energy), 2000);
      expect(set.referenceFor(Nutrient.totalFat), 70);
      expect(set.referenceFor(Nutrient.saturatedFat), 20);
      expect(set.referenceFor(Nutrient.carbohydrates), 260);
      expect(set.referenceFor(Nutrient.totalSugars), 90);
      expect(set.referenceFor(Nutrient.protein), 50);
      expect(set.referenceFor(Nutrient.sodium), 2400);
    });

    test('added sugars, fiber and trans fat have no reference intake', () {
      expect(set.referenceFor(Nutrient.addedSugars), isNull);
      expect(set.referenceFor(Nutrient.dietaryFiber), isNull);
      expect(set.referenceFor(Nutrient.transFat), isNull);
    });
  });

  group('trans fat has no %VD anywhere', () {
    test('no region defines a trans-fat reference', () {
      for (final region in VdRegion.values) {
        expect(
          VdReference.forRegion(region).referenceFor(Nutrient.transFat),
          isNull,
          reason: region.name,
        );
      }
    });
  });

  group('percentOf', () {
    final set = VdReference.forRegion(VdRegion.brazil);

    test('is amount over reference, as a percentage', () {
      expect(set.percentOf(1000, Nutrient.sodium), closeTo(50, 1e-9));
      expect(set.percentOf(150, Nutrient.carbohydrates), closeTo(50, 1e-9));
      expect(set.percentOf(2000, Nutrient.energy), closeTo(100, 1e-9));
    });

    test('an absent amount has no %VD', () {
      expect(set.percentOf(null, Nutrient.sodium), isNull);
    });

    test('a nutrient without a reference has no %VD even when present', () {
      expect(set.percentOf(5, Nutrient.transFat), isNull);
    });
  });

  group('percentagesFor', () {
    test('maps each nutrient to its %VD or null', () {
      const nutrients = Nutrients(
        energyKcal: 1000,
        carbohydrates: 150,
        transFat: 3,
      );

      final percentages = VdReference.forRegion(
        VdRegion.brazil,
      ).percentagesFor(nutrients);

      expect(percentages[Nutrient.energy], closeTo(50, 1e-9));
      expect(percentages[Nutrient.carbohydrates], closeTo(50, 1e-9));
      expect(percentages[Nutrient.transFat], isNull);
      expect(percentages[Nutrient.protein], isNull); // absent amount
    });
  });

  group('VdRegion.fromCountryCode', () {
    test('maps known country codes to their region', () {
      expect(VdRegion.fromCountryCode('BR'), VdRegion.brazil);
      expect(VdRegion.fromCountryCode('us'), VdRegion.unitedStates);
      expect(VdRegion.fromCountryCode('DE'), VdRegion.europeanUnion);
      expect(VdRegion.fromCountryCode('FR'), VdRegion.europeanUnion);
    });

    test('falls back to Brazil for unknown or missing codes', () {
      expect(VdRegion.fromCountryCode(null), VdRegion.brazil);
      expect(VdRegion.fromCountryCode('ZZ'), VdRegion.brazil);
    });
  });
}
