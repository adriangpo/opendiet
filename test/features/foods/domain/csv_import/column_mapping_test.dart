import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';

void main() {
  group('missingRequiredCsvFields', () {
    test('reports required fields absent from the selected mapping', () {
      const mappings = [
        ColumnMapping(
          columnIndex: 0,
          originalHeader: 'Protein',
          proposedField: CsvField.protein,
          selectedField: CsvField.protein,
        ),
      ];

      expect(
        missingRequiredCsvFields(mappings),
        [CsvField.name, CsvField.energyKcal],
      );
    });

    test('treats energy_kj as satisfying the required energy mapping', () {
      const mappings = [
        ColumnMapping(
          columnIndex: 0,
          originalHeader: 'Name',
          proposedField: CsvField.name,
          selectedField: CsvField.name,
        ),
        ColumnMapping(
          columnIndex: 1,
          originalHeader: 'Energy (kJ)',
          proposedField: CsvField.energyKj,
          selectedField: CsvField.energyKj,
        ),
      ];

      expect(missingRequiredCsvFields(mappings), isEmpty);
    });

    test('reports a required field changed back to ignore', () {
      const mappings = [
        ColumnMapping(
          columnIndex: 0,
          originalHeader: 'Name',
          proposedField: CsvField.name,
          selectedField: CsvField.ignore,
        ),
        ColumnMapping(
          columnIndex: 1,
          originalHeader: 'Energy',
          proposedField: CsvField.energyKcal,
          selectedField: CsvField.energyKcal,
        ),
      ];

      expect(missingRequiredCsvFields(mappings), [CsvField.name]);
    });
  });
}
