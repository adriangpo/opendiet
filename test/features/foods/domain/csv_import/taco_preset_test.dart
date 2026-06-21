import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';
import 'package:opendiet/features/foods/domain/csv_import/taco_preset.dart';

void main() {
  group('TacoPreset', () {
    test('maps TACO column names to canonical fields', () {
      final headers = [
        'Alimento',
        'Umidade (g)',
        'Energia (kcal)',
        'Proteína (g)',
        'Lipídios (g)',
        'Carboidrato (g)',
        'Fibra (g)',
        'Cinzas (g)',
        'Cálcio (mg)',
        'Magnésio (mg)',
        'Ferro (mg)',
        'Sódio (mg)',
        'Potássio (mg)',
        'Colesterol (mg)',
      ];

      final mappings = TacoPreset.proposeMapping(headers);

      expect(mappings, hasLength(14));
      _assertMapping(mappings[0], CsvField.name, 'Alimento');
      _assertMapping(mappings[1], CsvField.ignore, 'Umidade (g)');
      _assertMapping(mappings[2], CsvField.energyKcal, 'Energia (kcal)');
      _assertMapping(mappings[3], CsvField.protein, 'Proteína (g)');
      _assertMapping(mappings[4], CsvField.fat, 'Lipídios (g)');
      _assertMapping(mappings[5], CsvField.carbs, 'Carboidrato (g)');
      _assertMapping(mappings[6], CsvField.fiber, 'Fibra (g)');
      _assertMapping(mappings[7], CsvField.ignore, 'Cinzas (g)');
      _assertMapping(mappings[8], CsvField.micronutrient, 'Cálcio (mg)');
      expect(mappings[8].micronutrientKey, 'calcio_mg');
      _assertMapping(mappings[9], CsvField.micronutrient, 'Magnésio (mg)');
      expect(mappings[9].micronutrientKey, 'magnesio_mg');
      _assertMapping(mappings[10], CsvField.micronutrient, 'Ferro (mg)');
      expect(mappings[10].micronutrientKey, 'ferro_mg');
      _assertMapping(mappings[11], CsvField.sodiumMg, 'Sódio (mg)');
      _assertMapping(mappings[12], CsvField.micronutrient, 'Potássio (mg)');
      expect(mappings[12].micronutrientKey, 'potassio_mg');
      _assertMapping(mappings[13], CsvField.ignore, 'Colesterol (mg)');
    });

    test('user can override preset mappings', () {
      // Simulating user changing the Cinzas column from ignore to a mapping
      final headers = ['Alimento', 'Energia (kcal)', 'Cinzas (g)'];
      final mappings = TacoPreset.proposeMapping(headers);

      // User marks Cinzas as a micronutrient
      final overridden = mappings.map((m) {
        if (m.originalHeader == 'Cinzas (g)') {
          return ColumnMapping(
            columnIndex: m.columnIndex,
            originalHeader: m.originalHeader,
            proposedField: m.proposedField,
            selectedField: CsvField.micronutrient,
            micronutrientKey: 'cinzas_mg',
            isRequired: m.isRequired,
          );
        }
        return m;
      }).toList();

      expect(overridden[2].selectedField, CsvField.micronutrient);
      expect(overridden[2].micronutrientKey, 'cinzas_mg');
    });

    test('returns mappings using the smart header mapper for unknown cols', () {
      final headers = ['Alimento', 'Energia (kcal)', 'Some Custom Column'];

      final mappings = TacoPreset.proposeMapping(headers);
      expect(mappings[0].proposedField, CsvField.name);
      expect(mappings[1].proposedField, CsvField.energyKcal);
      // Unknown should use smart mapper -> ignore
      expect(mappings[2].proposedField, CsvField.ignore);
    });
  });
}

void _assertMapping(
  ColumnMapping mapping,
  CsvField expectedField,
  String expectedHeader,
) {
  expect(mapping.originalHeader, expectedHeader);
  expect(mapping.proposedField, expectedField);
  expect(mapping.selectedField, expectedField);
}
