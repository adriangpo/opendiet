import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The settings hub (S-13). This increment exposes the unit system (FR-024) and
/// the %VD reference region (FR-027); other sections arrive later.
class SettingsScreen extends ConsumerWidget {
  /// Creates the settings screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: switch (settings) {
        AsyncData(:final value) => _SettingsList(value),
        AsyncError() => Center(child: Text(l10n.settingsLoadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _SettingsList extends ConsumerWidget {
  const _SettingsList(this.settings);

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(settingsControllerProvider.notifier);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListTile(
          title: Text(l10n.settingsUnitSystem),
          subtitle: SegmentedButton<UnitSystem>(
            segments: [
              ButtonSegment(
                value: UnitSystem.metric,
                label: Text(l10n.unitSystemMetric),
              ),
              ButtonSegment(
                value: UnitSystem.imperial,
                label: Text(l10n.unitSystemImperial),
              ),
            ],
            selected: {settings.unitSystem},
            onSelectionChanged: (selection) =>
                unawaited(controller.setUnitSystem(selection.single)),
          ),
        ),
        ListTile(
          title: Text(l10n.settingsVdRegion),
          subtitle: DropdownButton<VdRegion>(
            value: settings.vdRegion,
            isExpanded: true,
            onChanged: (region) {
              if (region != null) unawaited(controller.setVdRegion(region));
            },
            items: [
              DropdownMenuItem(
                value: VdRegion.brazil,
                child: Text(l10n.vdRegionBrazil),
              ),
              DropdownMenuItem(
                value: VdRegion.unitedStates,
                child: Text(l10n.vdRegionUnitedStates),
              ),
              DropdownMenuItem(
                value: VdRegion.europeanUnion,
                child: Text(l10n.vdRegionEuropeanUnion),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
