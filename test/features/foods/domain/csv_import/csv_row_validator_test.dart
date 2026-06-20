import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_row_validator.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';
import 'package:opendiet/features/foods/domain/csv_import/csv_import_result.dart';
import 'package:opendiet/features/foods/domain/food.dart';

void main() {
  group('CsvRowValidator', () {
    final mappings = _mappings();

    test('validates a complete row', () {
      final row = _row(
        name: 'Arroz Integral',
        energy: '120',
        protein: '2.6',
        carbs: '26',
        fat: '1.0',
      );
      final result = CsvRowValidator.validate(row, mappings);
      if (result is ValidRow) {
        expect(result.name, 'Arroz Integral');
        expect(result.nutrients.energyKcal, 120);
        expect(result.nutrients.protein, 2.6);
        expect(result.nutrients.carbohydrates, 26);
        expect(result.nutrients.totalFat, 1.0);
        expect(result.basis, NutrientBasis.per100g);
      } else {
        fail('Expected valid row, got: ${(result as RejectedRow).reason}');
      }
    });

    test('rejects row with blank name', () {
      final row = _row(name: '', energy: '120');
      final result = CsvRowValidator.validate(row, mappings);
      if (result is RejectedRow) {
        expect(result.reason, contains('name'));
      } else {
        fail('Expected rejection');
      }
    });

    test('rejects row with missing energy', () {
      final row = _row(name: 'Test', energy: '');
      final result = CsvRowValidator.validate(row, mappings);
      if (result is RejectedRow) {
        expect(result.reason, contains('energy'));
      } else {
        fail('Expected rejection');
      }
    });

    test('rejects row with non-numeric energy', () {
      final row = _row(name: 'Test', energy: 'abc');
      final result = CsvRowValidator.validate(row, mappings);
      if (result is RejectedRow) {
        expect(result.reason, contains('energy'));
      } else {
        fail('Expected rejection');
      }
    });

    test('rejects row with negative numeric value', () {
      final row = _row(name: 'Test', energy: '120', protein: '-5');
      final result = CsvRowValidator.validate(row, mappings);
      if (result is RejectedRow) {
        expect(result.reason, contains('protein'));
        expect(result.reason, contains('negative'));
      } else {
        fail('Expected rejection');
      }
    });

    test('accepts zero as valid numeric', () {
      final row = _row(name: 'Zero Energy', energy: '0', protein: '0');
      final result = CsvRowValidator.validate(row, mappings);
      if (result is ValidRow) {
        expect(result.nutrients.energyKcal, 0);
        expect(result.nutrients.protein, 0);
      } else {
        fail('Expected valid row with zeros');
      }
    });

    test('converts energy_kj to kcal when kcal missing', () {
      final kjMappings = [
        ColumnMapping(
          columnIndex: 0,
          originalHeader: 'Name',
          proposedField: CsvField.name,
          selectedField: CsvField.name,
          micronutrientKey: null,
          isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 1,
          originalHeader: 'Energy (kJ)',
          proposedField: CsvField.energyKj,
          selectedField: CsvField.energyKj,
          micronutrientKey: null,
          isRequired: true,
        ),
      ];
      final row = ['Test', '840'];
      final result = CsvRowValidator.validate(row, kjMappings);
      if (result is ValidRow) {
        // 840 kJ / 4.184 ~= 200.8 kcal
        expect(result.nutrients.energyKcal, closeTo(200.8, 0.1));
      } else {
        fail('Expected valid row with kj conversion');
      }
    });

    test('prefers kcal over kj when both present', () {
      final bothMappings = [
        ColumnMapping(
          columnIndex: 0,
          originalHeader: 'Name',
          proposedField: CsvField.name,
          selectedField: CsvField.name,
          micronutrientKey: null,
          isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 1,
          originalHeader: 'Energy (kcal)',
          proposedField: CsvField.energyKcal,
          selectedField: CsvField.energyKcal,
          micronutrientKey: null,
          isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 2,
          originalHeader: 'Energy (kJ)',
          proposedField: CsvField.energyKj,
          selectedField: CsvField.energyKj,
          micronutrientKey: null,
          isRequired: false,
        ),
      ];
      final row = ['Test', '200', '840'];
      final result = CsvRowValidator.validate(row, bothMappings);
      if (result is ValidRow) {
        // kcal takes priority over kJ
        expect(result.nutrients.energyKcal, 200);
      } else {
        fail('Expected valid row preferring kcal');
      }
    });

    test('stores sodium_mg from sodium field', () {
      final naMappings = [
        ColumnMapping(
          columnIndex: 0,
          originalHeader: 'Name',
          proposedField: CsvField.name,
          selectedField: CsvField.name,
          micronutrientKey: null,
          isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 1,
          originalHeader: 'Energy',
          proposedField: CsvField.energyKcal,
          selectedField: CsvField.energyKcal,
          micronutrientKey: null,
          isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 2,
          originalHeader: 'Sodium (mg)',
          proposedField: CsvField.sodiumMg,
          selectedField: CsvField.sodiumMg,
          micronutrientKey: null,
          isRequired: false,
        ),
      ];
      final row = ['Test', '100', '500'];
      final result = CsvRowValidator.validate(row, naMappings);
      if (result is ValidRow) {
        expect(result.nutrients.sodiumMilligrams, 500);
      } else {
        fail('Expected valid row with sodium');
      }
    });

    test('rejects non-numeric value in numeric field', () {
      final row = _row(name: 'Test', energy: '120', fat: 'not-a-number');
      final result = CsvRowValidator.validate(row, mappings);
      if (result is RejectedRow) {
        expect(result.reason, contains('fat'));
      } else {
        fail('Expected rejection');
      }
    });

    test('includes micronutrients in parsed row', () {
      final microMappings = [
        ColumnMapping(
          columnIndex: 0, originalHeader: 'Name',
          proposedField: CsvField.name, selectedField: CsvField.name,
          micronutrientKey: null, isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 1, originalHeader: 'Energy',
          proposedField: CsvField.energyKcal,
          selectedField: CsvField.energyKcal,
          micronutrientKey: null, isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 2, originalHeader: 'Calcium (mg)',
          proposedField: CsvField.micronutrient,
          selectedField: CsvField.micronutrient,
          micronutrientKey: 'calcium_mg',
          isRequired: false,
        ),
      ];
      final row = ['Test', '100', '200'];
      final result = CsvRowValidator.validate(row, microMappings);
      if (result is ValidRow) {
        expect(result.nutrients.micronutrients['calcium_mg'], 200);
      } else {
        fail('Expected valid row with micronutrient');
      }
    });

    test('accepts per_serving basis with serving_size', () {
      final svMappings = [
        ColumnMapping(
          columnIndex: 0,
          originalHeader: 'Name',
          proposedField: CsvField.name,
          selectedField: CsvField.name,
          micronutrientKey: null,
          isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 1,
          originalHeader: 'Energy',
          proposedField: CsvField.energyKcal,
          selectedField: CsvField.energyKcal,
          micronutrientKey: null,
          isRequired: true,
        ),
        ColumnMapping(
          columnIndex: 2,
          originalHeader: 'Protein',
          proposedField: CsvField.protein,
          selectedField: CsvField.protein,
          micronutrientKey: null,
          isRequired: false,
        ),
        ColumnMapping(
          columnIndex: 3,
          originalHeader: 'Basis',
          proposedField: CsvField.basis,
          selectedField: CsvField.basis,
          micronutrientKey: null,
          isRequired: false,
        ),
        ColumnMapping(
          columnIndex: 4,
          originalHeader: 'Serving size',
          proposedField: CsvField.servingSize,
          selectedField: CsvField.servingSize,
          micronutrientKey: null,
          isRequired: false,
        ),
      ];
      final row = [
        'Test',
        '250', // energy
        '5', // protein
        'per_serving', // basis
        '100', // serving_size
      ];
      final result = CsvRowValidator.validate(row, svMappings);
      if (result is ValidRow) {
        expect(result.basis, NutrientBasis.perServing);
        expect(result.servingSizeMetric, 100);
      } else {
        fail('Expected valid row with per-serving');
      }
    });
  });
}

List<ColumnMapping> _mappings() => [
  ColumnMapping(
    columnIndex: 0,
    originalHeader: 'Name',
    proposedField: CsvField.name,
    selectedField: CsvField.name,
    micronutrientKey: null,
    isRequired: true,
  ),
  ColumnMapping(
    columnIndex: 1,
    originalHeader: 'Energy',
    proposedField: CsvField.energyKcal,
    selectedField: CsvField.energyKcal,
    micronutrientKey: null,
    isRequired: true,
  ),
  ColumnMapping(
    columnIndex: 2,
    originalHeader: 'Protein',
    proposedField: CsvField.protein,
    selectedField: CsvField.protein,
    micronutrientKey: null,
    isRequired: false,
  ),
  ColumnMapping(
    columnIndex: 3,
    originalHeader: 'Carbs',
    proposedField: CsvField.carbs,
    selectedField: CsvField.carbs,
    micronutrientKey: null,
    isRequired: false,
  ),
  ColumnMapping(
    columnIndex: 4,
    originalHeader: 'Fat',
    proposedField: CsvField.fat,
    selectedField: CsvField.fat,
    micronutrientKey: null,
    isRequired: false,
  ),
];

List<String> _row({
  required String name,
  required String energy,
  String protein = '',
  String carbs = '',
  String fat = '',
}) => [name, energy, protein, carbs, fat];
