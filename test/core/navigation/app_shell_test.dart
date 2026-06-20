import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../support/fake_settings_repository.dart';
import '../../support/test_app.dart';

void main() {
  List<Override> overrides() => [
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
  ];

  testWidgets('renders the four bottom-navigation tabs', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    expect(find.widgetWithText(NavigationDestination, 'Diary'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Foods'), findsOneWidget);
    expect(
      find.widgetWithText(NavigationDestination, 'Recipes'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(NavigationDestination, 'Settings'),
      findsOneWidget,
    );
  });

  testWidgets('starts on the Diary tab', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    expect(
      find.text('No entries yet. Log a food to start your day.'),
      findsOneWidget,
    );
  });

  testWidgets('switches to the Foods tab when tapped', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Foods'));
    await tester.pumpAndSettle();

    expect(
      find.text('No foods yet. Create a custom food or import a list.'),
      findsOneWidget,
    );
  });

  testWidgets('shows the settings controls on the Settings tab', (
    tester,
  ) async {
    await pumpAppShell(tester, overrides: overrides());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Unit system'), findsOneWidget);
    expect(find.text('%VD reference'), findsOneWidget);
  });

  testWidgets('opens the food editor from the Foods tab', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Foods'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('field-name')), findsOneWidget);
  });
}
