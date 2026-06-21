import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_import_providers.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_import_service.dart';
import 'package:opendiet/features/foods/data/csv_import/smart_header_mapper.dart';
import 'package:opendiet/features/foods/presentation/csv_import/csv_import_screen.dart';

import '../../../../support/fake_food_repository.dart';
import '../../../../support/test_app.dart';

void main() {
  testWidgets('renders step 1 - pick file', (tester) async {
    await pumpApp(
      tester,
      const CsvImportScreen(),
      overrides: [
        // Override the csv import service provider to avoid needing real
        // file_picker platform channel calls.
        csvImportServiceProvider.overrideWithValue(
          // In tests, the screen only renders the pick-file button.
          // The service is not used until a file is selected.
          _createFakeService(),
        ),
      ],
    );

    // The app bar should show the step 1 title.
    expect(find.text('Pick a file'), findsOneWidget);

    // The "Choose CSV" button should be present.
    expect(find.text('Choose CSV'), findsOneWidget);

    // The "Next" button should be disabled (no file selected).
    final nextButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Next'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(nextButton.onPressed, isNull);
  });
}

CsvImportService _createFakeService() => CsvImportService(
  foodRepository: FakeFoodRepository(),
  headerMapper: const SmartHeaderMapper(),
  idGenerator: _TestIdGenerator(),
  clock: FixedClock(DateTime(2026, 6, 19)),
);

class _TestIdGenerator implements IdGenerator {
  @override
  String newId() => 'csv-food';
}
