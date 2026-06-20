import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// The single user profile's settings (FR-024, FR-027, FR-022, FR-029).
///
/// [unitSystem] and [vdRegion] are independent of the UI [languageCode].
/// [dailyTarget] is optional: with none set, totals are still shown (FR-022).
@freezed
abstract class AppSettings with _$AppSettings {
  /// Creates a settings snapshot.
  const factory AppSettings({
    required UnitSystem unitSystem,
    required VdRegion vdRegion,
    String? languageCode,
    Nutrients? dailyTarget,
  }) = _AppSettings;

  /// Builds settings from their JSON form.
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// The out-of-the-box settings before any device defaults are applied.
  static const AppSettings defaults = AppSettings(
    unitSystem: UnitSystem.metric,
    vdRegion: VdRegion.brazil,
  );
}
