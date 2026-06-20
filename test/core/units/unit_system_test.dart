import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/units/unit_system.dart';

void main() {
  group('UnitSystem', () {
    test('metric displays grams and milliliters', () {
      expect(UnitSystem.metric.massUnit, MassUnit.gram);
      expect(UnitSystem.metric.volumeUnit, VolumeUnit.milliliter);
    });

    test('imperial displays ounces and fluid ounces', () {
      expect(UnitSystem.imperial.massUnit, MassUnit.ounce);
      expect(UnitSystem.imperial.volumeUnit, VolumeUnit.fluidOunce);
    });
  });
}
