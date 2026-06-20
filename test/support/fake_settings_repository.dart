import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:opendiet/features/settings/domain/settings_repository.dart';

/// An in-memory [SettingsRepository] for widget tests (no real database).
class FakeSettingsRepository implements SettingsRepository {
  /// Creates a fake seeded with [current].
  FakeSettingsRepository([this.current = AppSettings.defaults]);

  /// The settings currently held; updated on every [save].
  AppSettings current;

  @override
  Future<AppSettings> load() async => current;

  @override
  Future<void> save(AppSettings settings) async => current = settings;
}
