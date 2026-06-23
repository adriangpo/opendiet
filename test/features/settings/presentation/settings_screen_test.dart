import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:opendiet/features/settings/presentation/settings_screen.dart';

import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  testWidgets('switching to Imperial persists the choice', (tester) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    expect(repository.current.unitSystem, UnitSystem.metric);

    await tester.tap(find.text('Imperial'));
    await tester.pumpAndSettle();

    expect(repository.current.unitSystem, UnitSystem.imperial);
  });

  testWidgets('selecting a %VD region persists the choice', (tester) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    expect(repository.current.vdRegion, VdRegion.brazil);

    await tester.tap(find.text('Brazil')); // opens the dropdown
    await tester.pumpAndSettle();
    await tester.tap(find.text('United States').last);
    await tester.pumpAndSettle();

    expect(repository.current.vdRegion, VdRegion.unitedStates);
  });

  testWidgets('shows the Daily target row (FR-022)', (tester) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    expect(find.text('Daily target'), findsOneWidget);
  });

  testWidgets('shows the First-run setup row for re-running onboarding', (
    tester,
  ) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    expect(find.text('First-run setup'), findsOneWidget);
  });

  testWidgets('shows the Meal slots row (FR-019)', (tester) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    expect(find.text('Meal slots'), findsOneWidget);
  });

  testWidgets('shows the Open Food Facts account row (FR-012)', (
    tester,
  ) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    expect(find.text('Open Food Facts account'), findsOneWidget);
  });

  testWidgets('shows the Backup and restore row (FR-005, FR-006)', (
    tester,
  ) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    expect(find.text('Backup and restore'), findsOneWidget);
  });

  testWidgets('shows the Language row (FR-028)', (tester) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    await tester.scrollUntilVisible(find.text('Language'), 100);
    await tester.pump();

    expect(find.text('Language'), findsOneWidget);
    expect(find.text('System default'), findsOneWidget);
  });

  testWidgets('selecting a language persists the choice', (tester) async {
    final repository = FakeSettingsRepository();
    await pumpApp(
      tester,
      const SettingsScreen(),
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );

    await tester.scrollUntilVisible(find.text('System default'), 100);
    await tester.pump();

    expect(repository.current.languageCode, isNull);

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portuguese'));
    await tester.pumpAndSettle();

    expect(repository.current.languageCode, 'pt');
  });
}
