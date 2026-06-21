import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

/// Exposes the user's settings and applies edits, persisting each change.
@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() => ref.watch(settingsRepositoryProvider).load();

  /// Switches the unit system (FR-024).
  Future<void> setUnitSystem(UnitSystem unitSystem) =>
      _update((settings) => settings.copyWith(unitSystem: unitSystem));

  /// Switches the %VD reference region (FR-027).
  Future<void> setVdRegion(VdRegion region) =>
      _update((settings) => settings.copyWith(vdRegion: region));

  /// Sets (or clears) the daily nutrition target (FR-022).
  Future<void> setDailyTarget(Nutrients? target) =>
      _update((settings) => settings.copyWith(dailyTarget: target));

  /// Completes S-18 while applying its local settings.
  Future<void> completeOnboarding({
    required UnitSystem unitSystem,
    required Nutrients? dailyTarget,
  }) => _update(
    (settings) => settings.copyWith(
      unitSystem: unitSystem,
      dailyTarget: dailyTarget,
      onboardingCompleted: true,
    ),
  );

  /// Skips S-18 without changing optional setup values.
  Future<void> skipOnboarding() =>
      _update((settings) => settings.copyWith(onboardingCompleted: true));

  Future<void> _update(AppSettings Function(AppSettings current) change) async {
    final repository = ref.read(settingsRepositoryProvider);
    final updated = change(await future);
    state = AsyncData(updated);
    await repository.save(updated);
  }
}
