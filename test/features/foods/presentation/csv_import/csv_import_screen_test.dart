import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_import_providers.dart';
import 'package:opendiet/features/foods/presentation/csv_import/csv_import_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/test_app.dart';

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
    final nextButton = tester.widget<FilledButton>(find.text('Next'));
    expect(nextButton.onPressed, isNull);
  });
}

// Placeholder for a fake service; actual file_picker interaction is not tested.
Object _createFakeService() {
  // This is a workaround - the service is only needed to exist in the provider
  // tree. The screen won't call it until a file is picked.
  // We override with a stub since the screen uses ref.read to access the
  // service only in response to user actions.
  throw UnimplementedError(
    'This test does not trigger file picking; the provider override '
    'exists only to satisfy the dependency tree.',
  );
}
