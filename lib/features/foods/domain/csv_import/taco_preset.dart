import 'package:opendiet/features/foods/data/csv_import/smart_header_mapper.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';

/// A built-in preset that maps TACO-export columns to canonical fields
/// (FR-030). OpenDiet ships no TACO data; the preset only knows the column
/// layout.
abstract final class TacoPreset {
  /// Maps [headers] using TACO-specific overrides on top of the generic
  /// smart header mapper. The user can still adjust the result before import.
  static List<ColumnMapping> proposeMapping(List<String> headers) {
    const mapper = SmartHeaderMapper();
    final generic = mapper.proposeMapping(headers);

    return [for (final mapping in generic) _override(headers, mapping)];
  }

  static ColumnMapping _override(List<String> headers, ColumnMapping mapping) {
    // TACO columns that should be ignored (not nutritional data).
    const skip = {'Umidade (g)', 'Cinzas (g)', 'Colesterol (mg)'};

    if (skip.contains(mapping.originalHeader)) {
      return mapping.copyWith(
        proposedField: CsvField.ignore,
        selectedField: CsvField.ignore,
      );
    }

    // Leave the generic mapper's proposal as-is.
    return mapping;
  }
}
