import 'package:opendiet/features/settings/domain/app_settings.dart';

/// Persists and retrieves the single profile's settings (FR-022, FR-024).
abstract interface class SettingsRepository {
  /// The stored settings, or the built-in defaults when none are saved.
  Future<AppSettings> load();

  /// Persists [settings].
  Future<void> save(AppSettings settings);
}
