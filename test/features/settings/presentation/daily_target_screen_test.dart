import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:opendiet/features/settings/presentation/daily_target_screen.dart';

import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  group('DailyTargetScreen', () {
    Future<void> pumpScreen(
      WidgetTester tester, {
      required FakeSettingsRepository repository,
    }) => pumpApp(
      tester,
      const DailyTargetScreen(),
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    testWidgets('renders energy, protein, carbs, fat fields', (tester) async {
      await pumpScreen(tester, repository: FakeSettingsRepository());

      expect(find.byKey(const Key('field-energy')), findsOneWidget);
      expect(find.byKey(const Key('field-protein')), findsOneWidget);
      expect(
        find.byKey(const Key('field-carbohydrates')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('field-totalFat')), findsOneWidget);
      expect(find.byKey(const Key('field-sodium')), findsOneWidget);
      expect(find.byKey(const Key('field-dietaryFiber')), findsOneWidget);
      expect(find.byKey(const Key('clear-target')), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('prefills fields from existing target', (tester) async {
      final repository = FakeSettingsRepository(
        AppSettings.defaults.copyWith(
          dailyTarget: const Nutrients(
            energyKcal: 2000,
            protein: 120,
            carbohydrates: 220,
            totalFat: 70,
            sodiumMilligrams: 2000,
            dietaryFiber: 30,
          ),
        ),
      );
      await pumpScreen(tester, repository: repository);

      expect(
        tester
            .widget<TextField>(find.byKey(const Key('field-energy')))
            .controller!
            .text,
        '2000',
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('field-protein')))
            .controller!
            .text,
        '120',
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('field-carbohydrates')))
            .controller!
            .text,
        '220',
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('field-totalFat')))
            .controller!
            .text,
        '70',
      );
    });

    testWidgets('saves target and pops back', (tester) async {
      final repository = FakeSettingsRepository();
      await pumpScreen(tester, repository: repository);

      await tester.enterText(
        find.byKey(const Key('field-energy')),
        '1800',
      );
      await tester.enterText(
        find.byKey(const Key('field-protein')),
        '100',
      );
      await tester.enterText(
        find.byKey(const Key('field-carbohydrates')),
        '200',
      );
      await tester.enterText(
        find.byKey(const Key('field-totalFat')),
        '60',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final target = repository.current.dailyTarget;
      expect(target?.energyKcal, 1800);
      expect(target?.protein, 100);
      expect(target?.carbohydrates, 200);
      expect(target?.totalFat, 60);
    });

    testWidgets('clear target removes it and pops back', (tester) async {
      final repository = FakeSettingsRepository(
        AppSettings.defaults.copyWith(
          dailyTarget: const Nutrients(energyKcal: 2000),
        ),
      );
      await pumpScreen(tester, repository: repository);

      await tester.tap(find.text('Clear target'));
      await tester.pumpAndSettle();

      expect(repository.current.dailyTarget, isNull);
    });

    testWidgets('shows error on invalid value', (tester) async {
      final repository = FakeSettingsRepository();
      await pumpScreen(tester, repository: repository);

      await tester.enterText(
        find.byKey(const Key('field-energy')),
        '-100',
      );
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Enter valid, non-negative numbers'), findsOneWidget);
    });
  });
}
