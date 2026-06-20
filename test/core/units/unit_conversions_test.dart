import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/units/unit_conversions.dart';

void main() {
  group('MassConverter', () {
    test('grams convert to themselves', () {
      expect(MassConverter.toGrams(250, MassUnit.gram), 250);
      expect(MassConverter.fromGrams(250, MassUnit.gram), 250);
    });

    test('one ounce is 28.349523125 grams', () {
      expect(
        MassConverter.toGrams(1, MassUnit.ounce),
        closeTo(28.349523125, 1e-9),
      );
    });

    test('one pound is 453.59237 grams', () {
      expect(
        MassConverter.toGrams(1, MassUnit.pound),
        closeTo(453.59237, 1e-9),
      );
    });

    test('sixteen ounces equal one pound', () {
      expect(
        MassConverter.toGrams(16, MassUnit.ounce),
        closeTo(MassConverter.toGrams(1, MassUnit.pound), 1e-9),
      );
    });

    test('round-trips ounces through grams', () {
      final grams = MassConverter.toGrams(7.5, MassUnit.ounce);
      expect(
        MassConverter.fromGrams(grams, MassUnit.ounce),
        closeTo(7.5, 1e-9),
      );
    });

    test('zero is zero in every unit', () {
      expect(MassConverter.toGrams(0, MassUnit.pound), 0);
      expect(MassConverter.fromGrams(0, MassUnit.ounce), 0);
    });
  });

  group('VolumeConverter', () {
    test('milliliters convert to themselves', () {
      expect(VolumeConverter.toMilliliters(330, VolumeUnit.milliliter), 330);
    });

    test('one US fluid ounce is 29.5735295625 milliliters', () {
      expect(
        VolumeConverter.toMilliliters(1, VolumeUnit.fluidOunce),
        closeTo(29.5735295625, 1e-9),
      );
    });

    test('round-trips fluid ounces through milliliters', () {
      final ml = VolumeConverter.toMilliliters(12, VolumeUnit.fluidOunce);
      expect(
        VolumeConverter.fromMilliliters(ml, VolumeUnit.fluidOunce),
        closeTo(12, 1e-9),
      );
    });
  });

  group('EnergyConverter', () {
    test('one kilocalorie is 4.184 kilojoules', () {
      expect(
        EnergyConverter.kilocaloriesToKilojoules(1),
        closeTo(4.184, 1e-12),
      );
    });

    test('round-trips kilojoules through kilocalories', () {
      expect(
        EnergyConverter.kilojoulesToKilocalories(
          EnergyConverter.kilocaloriesToKilojoules(2000),
        ),
        closeTo(2000, 1e-9),
      );
    });
  });

  group('SodiumSaltConverter', () {
    test('salt equals sodium times 2.5 (same mass unit)', () {
      expect(SodiumSaltConverter.sodiumToSalt(400), closeTo(1000, 1e-9));
    });

    test('sodium equals salt divided by 2.5', () {
      expect(SodiumSaltConverter.saltToSodium(2.5), closeTo(1, 1e-9));
    });

    test('round-trips sodium through salt', () {
      expect(
        SodiumSaltConverter.saltToSodium(
          SodiumSaltConverter.sodiumToSalt(1200),
        ),
        closeTo(1200, 1e-9),
      );
    });
  });
}
