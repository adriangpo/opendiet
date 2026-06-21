import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/foods/data/off_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';
import 'package:opendiet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';

import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  group('OnboardingScreen (S-18)', () {
    Future<void> pumpScreen(
      WidgetTester tester, {
      required FakeSettingsRepository settingsRepository,
      required FakeOffRepository offRepository,
      void Function()? onFinished,
    }) {
      return pumpApp(
        tester,
        OnboardingScreen(onFinished: onFinished),
        overrides: [
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          offRepositoryProvider.overrideWithValue(offRepository),
        ],
      );
    }

    testWidgets('renders units, optional target, and optional OFF account', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        settingsRepository: FakeSettingsRepository(AppSettings.defaults),
        offRepository: FakeOffRepository(),
      );

      expect(find.text('Welcome to OpenDiet'), findsOneWidget);
      expect(find.text('Metric'), findsOneWidget);
      expect(find.text('Imperial'), findsOneWidget);
      expect(find.text('Daily target'), findsOneWidget);
      expect(find.text('Open Food Facts'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('Skip marks onboarding complete without an OFF account', (
      tester,
    ) async {
      var finished = false;
      final settingsRepository = FakeSettingsRepository(AppSettings.defaults);
      final offRepository = FakeOffRepository();
      await pumpScreen(
        tester,
        settingsRepository: settingsRepository,
        offRepository: offRepository,
        onFinished: () => finished = true,
      );

      await tester.tap(find.text('Skip'));
      await tester.pump();

      expect(settingsRepository.current.onboardingCompleted, isTrue);
      expect(settingsRepository.current.unitSystem, UnitSystem.metric);
      expect(settingsRepository.current.dailyTarget, isNull);
      expect(offRepository.loginAttempts, isEmpty);
      expect(finished, isTrue);
    });

    testWidgets('Start persists unit system and a complete target', (
      tester,
    ) async {
      final settingsRepository = FakeSettingsRepository(AppSettings.defaults);
      await pumpScreen(
        tester,
        settingsRepository: settingsRepository,
        offRepository: FakeOffRepository(),
      );

      await tester.tap(find.text('Imperial'));
      await tester.enterText(find.byKey(const Key('field-energy')), '1800');
      await tester.enterText(find.byKey(const Key('field-protein')), '100');
      await tester.enterText(
        find.byKey(const Key('field-carbohydrates')),
        '200',
      );
      await tester.enterText(find.byKey(const Key('field-totalFat')), '60');
      await tester.tap(find.text('Start'));
      await tester.pump();

      expect(settingsRepository.current.onboardingCompleted, isTrue);
      expect(settingsRepository.current.unitSystem, UnitSystem.imperial);
      expect(
        settingsRepository.current.dailyTarget,
        const Nutrients(
          energyKcal: 1800,
          protein: 100,
          carbohydrates: 200,
          totalFat: 60,
        ),
      );
    });

    testWidgets('Start accepts an empty optional target', (tester) async {
      final settingsRepository = FakeSettingsRepository(AppSettings.defaults);
      await pumpScreen(
        tester,
        settingsRepository: settingsRepository,
        offRepository: FakeOffRepository(),
      );

      await tester.tap(find.text('Start'));
      await tester.pump();

      expect(settingsRepository.current.onboardingCompleted, isTrue);
      expect(settingsRepository.current.dailyTarget, isNull);
    });

    testWidgets('Start rejects a partial target without completing', (
      tester,
    ) async {
      final settingsRepository = FakeSettingsRepository(AppSettings.defaults);
      await pumpScreen(
        tester,
        settingsRepository: settingsRepository,
        offRepository: FakeOffRepository(),
      );

      await tester.enterText(find.byKey(const Key('field-energy')), '1800');
      await tester.tap(find.text('Start'));
      await tester.pump();

      expect(settingsRepository.current.onboardingCompleted, isFalse);
      expect(find.text('Enter valid, non-negative numbers'), findsOneWidget);
    });

    testWidgets('entered OFF account is validated before completion', (
      tester,
    ) async {
      final settingsRepository = FakeSettingsRepository(AppSettings.defaults);
      final offRepository = FakeOffRepository();
      await pumpScreen(
        tester,
        settingsRepository: settingsRepository,
        offRepository: offRepository,
      );

      await tester.enterText(find.byKey(const Key('field-off-user-id')), 'ada');
      await tester.enterText(
        find.byKey(const Key('field-off-password')),
        'secret',
      );
      await tester.tap(find.text('Start'));
      await tester.pump();

      expect(offRepository.loginAttempts, [
        (userId: 'ada', password: 'secret'),
      ]);
      expect(settingsRepository.current.onboardingCompleted, isTrue);
    });

    testWidgets('OFF failure keeps the step skippable and preserves entry', (
      tester,
    ) async {
      final settingsRepository = FakeSettingsRepository(AppSettings.defaults);
      final offRepository = FakeOffRepository(loginResult: false);
      await pumpScreen(
        tester,
        settingsRepository: settingsRepository,
        offRepository: offRepository,
      );

      await tester.enterText(find.byKey(const Key('field-off-user-id')), 'ada');
      await tester.enterText(
        find.byKey(const Key('field-off-password')),
        'secret',
      );
      await tester.tap(find.text('Start'));
      await tester.pump();

      expect(settingsRepository.current.onboardingCompleted, isFalse);
      expect(find.text('Could not sign in to Open Food Facts'), findsOneWidget);
      expect(find.text('ada'), findsOneWidget);

      await tester.tap(find.text('Skip'));
      await tester.pump();

      expect(settingsRepository.current.onboardingCompleted, isTrue);
    });
  });
}

class FakeOffRepository implements OffRepository {
  FakeOffRepository({this.loginResult = true});

  final bool loginResult;
  final List<({String password, String userId})> loginAttempts = [];

  @override
  Future<OffBarcodeResult> getProductByBarcode(String barcode) async {
    return const OffBarcodeNotFound();
  }

  @override
  Future<bool> login(String userId, String password) async {
    loginAttempts.add((userId: userId, password: password));
    return loginResult;
  }

  @override
  Future<void> saveProduct(Food food) async {}

  @override
  Future<OffSearchResult> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 25,
  }) async {
    return OffSearchResult(products: const [], totalCount: 0);
  }
}
