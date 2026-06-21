import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_import_service.dart';
import 'package:opendiet/features/foods/data/csv_import/smart_header_mapper.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';

/// The CSV import service, wired to the real repository and clock.
final csvImportServiceProvider = Provider<CsvImportService>((ref) {
  return CsvImportService(
    foodRepository: ref.watch(foodRepositoryProvider),
    headerMapper: const SmartHeaderMapper(),
    idGenerator: ref.watch(idGeneratorProvider),
    clock: ref.watch(clockProvider),
  );
});
