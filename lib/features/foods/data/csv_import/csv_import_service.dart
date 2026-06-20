import 'package:csv/csv.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_row_validator.dart';
import 'package:opendiet/features/foods/data/csv_import/smart_header_mapper.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';
import 'package:opendiet/features/foods/domain/csv_import/csv_import_result.dart';
import 'package:opendiet/features/foods/domain/food_repository.dart';

/// Orchestrates CSV food import: parse, map headers, validate rows, save
/// valid foods to the repository (FR-013, FR-014).
class CsvImportService {
  CsvImportService({
    required FoodRepository foodRepository,
    required SmartHeaderMapper headerMapper,
    required IdGenerator idGenerator,
    required Clock clock,
  }) : _foodRepository = foodRepository,
       _headerMapper = headerMapper,
       _idGenerator = idGenerator,
       _clock = clock;

  final FoodRepository _foodRepository;
  final SmartHeaderMapper _headerMapper;
  final IdGenerator _idGenerator;
  final Clock _clock;

  /// Parses [csvContent], proposes a mapping, and returns both the mapping
  /// proposal and the raw parsed rows for preview.
  CsvParseResult parseCsv(String csvContent) {
    final rows = Csv().decode(csvContent);
    if (rows.isEmpty) {
      return const CsvParseResult(headers: [], dataRows: [], mappings: []);
    }

    final headers = rows.first.map((e) => e.toString()).toList();
    final mappings = _headerMapper.proposeMapping(headers);

    // Data rows (skip header).
    final dataRows = rows.length > 1
        ? rows
              .sublist(1)
              .map(
                (row) => row.map((e) => e.toString()).toList(),
              )
              .toList()
        : <List<String>>[];

    return CsvParseResult(
      headers: headers,
      dataRows: dataRows,
      mappings: mappings,
    );
  }

  /// Imports all valid rows from [csvContent] using [mappings].
  ///
  /// Valid rows are converted to [Food] entities and saved via the repository.
  /// Returns a summary with imported/rejected counts and per-row rejection
  /// reasons.
  Future<CsvImportResult> importFromCsv(
    String csvContent, {
    List<ColumnMapping>? overrideMappings,
  }) async {
    final parseResult = parseCsv(csvContent);
    final mappings = overrideMappings ?? parseResult.mappings;
    final now = _clock.now();

    var importedCount = 0;
    final rejectedRows = <RejectedRow>[];

    for (var i = 0; i < parseResult.dataRows.length; i++) {
      final rowValues = parseResult.dataRows[i];
      // Row number is 1-indexed: row 1 = header, row 2 = first data row.
      final rowNumber = i + 2;

      final result = CsvRowValidator.validate(rowValues, mappings);

      if (result is ValidRow) {
        final food = result.toFood(_idGenerator.newId(), now);
        await _foodRepository.saveFood(food);
        importedCount++;
      } else if (result is RejectedRow) {
        rejectedRows.add(
          RejectedRow(
            rowNumber: rowNumber,
            reason: result.reason,
          ),
        );
      }
    }

    return CsvImportResult(
      importedCount: importedCount,
      rejectedCount: rejectedRows.length,
      rejectedRowReasons: rejectedRows,
    );
  }

  /// Generates a [CsvImportResult] by running the full pipeline on
  /// [csvContent]: parsing, mapping via [SmartHeaderMapper], validation, and
  /// saving. Convenience wrapper.
  Future<CsvImportResult> runFullImport(String csvContent) =>
      importFromCsv(csvContent);
}

/// Result of parsing a CSV: headers, data rows, and the proposed mapping.
class CsvParseResult {
  const CsvParseResult({
    required this.headers,
    required this.dataRows,
    required this.mappings,
  });

  final List<String> headers;
  final List<List<String>> dataRows;
  final List<ColumnMapping> mappings;

  int get rowCount => dataRows.length;
}
