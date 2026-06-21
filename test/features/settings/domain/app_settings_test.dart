import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';

void main() {
  group('AppSettings', () {
    test(
      'defaults are metric, Brazil region, no target, no language override',
      () {
        expect(AppSettings.defaults.unitSystem, UnitSystem.metric);
        expect(AppSettings.defaults.vdRegion, VdRegion.brazil);
        expect(AppSettings.defaults.dailyTarget, isNull);
        expect(AppSettings.defaults.languageCode, isNull);
        expect(AppSettings.defaults.onboardingCompleted, isFalse);
      },
    );

    test('round-trips through json including a daily target', () {
      const settings = AppSettings(
        unitSystem: UnitSystem.imperial,
        vdRegion: VdRegion.unitedStates,
        languageCode: 'pt',
        onboardingCompleted: true,
        dailyTarget: Nutrients(energyKcal: 2200, protein: 120),
      );

      final restored = AppSettings.fromJson(settings.toJson());

      expect(restored, settings);
      expect(restored.dailyTarget?.energyKcal, 2200);
    });

    test('round-trips with no target set (FR-022 allows no target)', () {
      final restored = AppSettings.fromJson(AppSettings.defaults.toJson());

      expect(restored, AppSettings.defaults);
    });
  });
}
