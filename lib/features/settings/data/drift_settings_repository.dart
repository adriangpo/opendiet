import 'package:drift/drift.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:opendiet/features/settings/domain/settings_repository.dart';

/// The settings are pinned to a single row at this id.
const int _settingsRowId = 0;

/// Drift-backed [SettingsRepository].
class DriftSettingsRepository implements SettingsRepository {
  /// Creates a repository over [_database].
  DriftSettingsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<AppSettings> load() async {
    final row = await (_database.select(
      _database.appSettingsRows,
    )..where((row) => row.id.equals(_settingsRowId))).getSingleOrNull();
    if (row == null) return AppSettings.defaults;
    return AppSettings(
      unitSystem: row.unitSystem,
      vdRegion: row.vdRegion,
      languageCode: row.languageCode,
      dailyTarget: row.dailyTarget,
    );
  }

  @override
  Future<void> save(AppSettings settings) => _database
      .into(_database.appSettingsRows)
      .insertOnConflictUpdate(
        AppSettingsRowsCompanion(
          id: const Value(_settingsRowId),
          unitSystem: Value(settings.unitSystem),
          vdRegion: Value(settings.vdRegion),
          languageCode: Value(settings.languageCode),
          dailyTarget: Value(settings.dailyTarget),
        ),
      );
}
