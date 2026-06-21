import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_import_service.dart';
import 'package:opendiet/features/foods/data/csv_import/smart_header_mapper.dart';
import 'package:opendiet/features/foods/domain/food.dart';

import '../../../../support/fake_food_repository.dart';

void main() {
  group('CsvImportService', () {
    late FakeFoodRepository repository;
    late CsvImportService service;

    setUp(() {
      repository = FakeFoodRepository();
      service = CsvImportService(
        foodRepository: repository,
        headerMapper: const SmartHeaderMapper(),
        idGenerator: _TestIdGenerator(),
        clock: FixedClock(DateTime(2026, 6, 19)),
      );
    });

    test('imports valid rows from CSV content', () async {
      const csv = '''
Name,Energy,Protein,Carbs,Fat
Arroz Integral,120,2.6,26,1.0
Frango Grelhado,200,30,0,7.0''';

      final result = await service.importFromCsv(csv);

      expect(result.importedCount, 2);
      expect(result.rejectedCount, 0);
      expect(result.rejectedRowReasons, isEmpty);

      final foods = await repository.allFoods();
      expect(foods, hasLength(2));
      expect(foods[0].name, 'Arroz Integral');
      expect(foods[0].source, FoodSource.imported);
      expect(foods[0].nutrients.energyKcal, 120);
      expect(foods[1].name, 'Frango Grelhado');
      expect(foods[1].nutrients.protein, 30);
    });

    test('skips rejected rows without aborting valid ones', () async {
      const csv = '''
Name,Energy,Protein
Valid Food,100,10
,200,5
Also Valid,150,20
Bad Energy,abc,5''';

      final result = await service.importFromCsv(csv);

      expect(result.importedCount, 2);
      expect(result.rejectedCount, 2);
      expect(result.rejectedRowReasons, hasLength(2));

      final foods = await repository.allFoods();
      expect(foods, hasLength(2));
      expect(foods[0].name, 'Valid Food');
      expect(foods[1].name, 'Also Valid');
    });

    test('handles header-only file (no data rows)', () async {
      const csv = 'Name,Energy,Protein,Fat';

      final result = await service.importFromCsv(csv);

      expect(result.importedCount, 0);
      expect(result.rejectedCount, 0);
    });

    test('rejects rows when the required name column is unmapped', () async {
      const csv = '''
Energy,Protein
100,10
200,20''';

      final result = await service.importFromCsv(csv);

      expect(result.importedCount, 0);
      expect(result.rejectedCount, 2);
      expect(result.rejectedRowReasons, hasLength(2));
      expect(result.rejectedRowReasons.first.reason, contains('name'));

      final foods = await repository.allFoods();
      expect(foods, isEmpty);
    });

    test('handles empty content', () async {
      final result = await service.importFromCsv('');

      expect(result.importedCount, 0);
      expect(result.rejectedCount, 0);
    });

    test('handles custom column mapping proposals', () async {
      const csv = '''
Product,Kcal,Proteina,Gordura
Leite,60,3.0,3.5''';

      final result = await service.importFromCsv(csv);

      expect(result.importedCount, 1);
      final foods = await repository.allFoods();
      expect(foods[0].name, 'Leite');
      expect(foods[0].nutrients.energyKcal, 60);
    });

    test('imported foods have correct source and basis defaults', () async {
      const csv = 'Name,Energy\nOats,180';
      final result = await service.importFromCsv(csv);

      expect(result.importedCount, 1);
      final foods = await repository.allFoods();
      expect(foods[0].source, FoodSource.imported);
      expect(foods[0].basis, NutrientBasis.per100g);
    });

    test('provides rejected row reasons with row numbers', () async {
      const csv = '''
Name,Energy
Valid,100
,200
BadPerRow,abc''';

      final result = await service.importFromCsv(csv);

      expect(result.importedCount, 1);
      expect(result.rejectedCount, 2);
      expect(result.rejectedRowReasons, hasLength(2));
      // Row 3 (row 1 = header, row 2 = valid) has blank name
      expect(result.rejectedRowReasons[0].rowNumber, 3);
      expect(result.rejectedRowReasons[0].reason, contains('name'));
      // Row 4 has bad energy
      expect(result.rejectedRowReasons[1].rowNumber, 4);
      expect(result.rejectedRowReasons[1].reason, contains('energy'));
    });

    test('parseCsv returns correct structure', () {
      const csv = 'Name,Energy,Protein\nFoodA,100,10\nFoodB,200,20';
      final parsed = service.parseCsv(csv);

      expect(parsed.headers, ['Name', 'Energy', 'Protein']);
      expect(parsed.dataRows, hasLength(2));
      expect(parsed.dataRows[0], ['FoodA', '100', '10']);
      expect(parsed.mappings, hasLength(3));
      expect(parsed.rowCount, 2);
    });
  });
}

class _TestIdGenerator implements IdGenerator {
  var _counter = 0;

  @override
  String newId() => 'test-id-${_counter++}';
}
