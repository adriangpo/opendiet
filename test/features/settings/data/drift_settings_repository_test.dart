import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/settings/data/drift_settings_repository.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';

void main() {
  late AppDatabase database;
  late DriftSettingsRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftSettingsRepository(database);
  });
  tearDown(() => database.close());

  test('loads built-in defaults when nothing is stored (FR-022)', () async {
    expect(await repository.load(), AppSettings.defaults);
  });

  test('round-trips settings with a daily target', () async {
    const settings = AppSettings(
      unitSystem: UnitSystem.imperial,
      vdRegion: VdRegion.unitedStates,
      languageCode: 'pt',
      onboardingCompleted: true,
      dailyTarget: Nutrients(energyKcal: 2200, protein: 120),
    );

    await repository.save(settings);

    expect(await repository.load(), settings);
  });

  test('round-trips settings with no target', () async {
    await repository.save(AppSettings.defaults);

    expect(await repository.load(), AppSettings.defaults);
  });
}
