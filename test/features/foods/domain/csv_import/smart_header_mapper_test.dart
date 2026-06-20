import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/data/csv_import/smart_header_mapper.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';

void main() {
  group('SmartHeaderMapper', () {
    late SmartHeaderMapper mapper;

    setUp(() {
      mapper = const SmartHeaderMapper();
    });

    group('proposeMapping', () {
      test('maps English headers', () {
        final headers = ['Name', 'Energy (kcal)', 'Protein', 'Fat'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings, hasLength(4));
        expect(mappings[0].proposedField, CsvField.name);
        expect(mappings[1].proposedField, CsvField.energyKcal);
        expect(mappings[2].proposedField, CsvField.protein);
        expect(mappings[3].proposedField, CsvField.fat);
      });

      test('maps Portuguese headers', () {
        final headers = ['Nome', 'Calorias', 'Proteína', 'Gorduras totais'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings, hasLength(4));
        expect(mappings[0].proposedField, CsvField.name);
        expect(mappings[1].proposedField, CsvField.energyKcal);
        expect(mappings[2].proposedField, CsvField.protein);
        expect(mappings[3].proposedField, CsvField.fat);
      });

      test('maps Brazilian-specific nutrient headers', () {
        final headers = [
          'Açúcares adicionados',
          'Gorduras trans',
          'Carboidratos',
          'Fibra',
        ];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.addedSugars);
        expect(mappings[1].proposedField, CsvField.transFat);
        expect(mappings[2].proposedField, CsvField.carbs);
        expect(mappings[3].proposedField, CsvField.fiber);
      });

      test('detects units in headers', () {
        final headers = ['Sodium (mg)', 'Salt (g)'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.sodiumMg);
        expect(mappings[1].proposedField, CsvField.salt);
      });

      test('maps energy_kj separately', () {
        final headers = ['Energy (kJ)'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.energyKj);
      });

      test('maps barcode header', () {
        final headers = ['Barcode'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.barcode);
      });

      test('maps serving headers', () {
        final headers = ['Serving size', 'Unit'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.servingSize);
        expect(mappings[1].proposedField, CsvField.servingUnit);
      });

      test('maps Portuguese serving headers', () {
        final headers = ['Porção', 'Unidade'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.servingSize);
        expect(mappings[1].proposedField, CsvField.servingUnit);
      });

      test('unrecognized headers map to ignore', () {
        final headers = ['SomeRandomColumn', 'NotARealField'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.ignore);
        expect(mappings[1].proposedField, CsvField.ignore);
      });

      test('deduplicates headers by suffix', () {
        final headers = ['carbs_g', 'sugars_g', 'fat_g'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.carbs);
        expect(mappings[1].proposedField, CsvField.sugars);
        expect(mappings[2].proposedField, CsvField.fat);
      });

      test('handles empty header list', () {
        final mappings = mapper.proposeMapping([]);
        expect(mappings, isEmpty);
      });

      test('trims and normalizes headers', () {
        final headers = ['  Name  ', 'ENERGY (KCAL)'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.name);
        expect(mappings[1].proposedField, CsvField.energyKcal);
      });

      test('detects micronutrients from unknown headers with units', () {
        final headers = ['Calcium (mg)', 'Iron (mg)', 'Vitamin C (mg)'];
        final mappings = mapper.proposeMapping(headers);
        expect(mappings[0].proposedField, CsvField.micronutrient);
        expect(mappings[0].micronutrientKey, 'calcium_mg');
        expect(mappings[1].proposedField, CsvField.micronutrient);
        expect(mappings[1].micronutrientKey, 'iron_mg');
        expect(mappings[2].proposedField, CsvField.micronutrient);
        expect(mappings[2].micronutrientKey, 'vitamin_c_mg');
      });
    });

    group('normalizeHeader', () {
      test('lowercases and trims', () {
        expect(mapper.normalizeHeader('  Name  '), 'name');
      });

      test('strips punctuation and units', () {
        expect(mapper.normalizeHeader('Energy (kcal)'), 'energy kcal');
      });

      test('collapses whitespace', () {
        expect(mapper.normalizeHeader('Saturated   Fat'), 'saturated fat');
      });
    });
  });
}
