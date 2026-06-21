import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
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
          title: Text(l10n.settingsDailyTarget),
          subtitle: Text(_dailyTargetSubtitle(l10n, settings.dailyTarget)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/settings/target'),
        ),
        ListTile(
          title: Text(l10n.settingsMealSlots),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/settings/meals'),
        ),
        ListTile(
          title: Text(l10n.settingsReminders),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/settings/reminders'),
        ),
        const Divider(),
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

  String _dailyTargetSubtitle(AppLocalizations l10n, Nutrients? target) {
    if (target == null) return l10n.settingsDailyTargetNone;
    final parts = <String>[];
    if (target.energyKcal != null) {
      parts.add('${target.energyKcal!.toInt()} kcal');
    }
    if (target.protein != null) {
      parts.add(
        '${target.protein!.toInt()}g '
        '${l10n.nutrientProtein.toLowerCase()}',
      );
    }
    if (target.carbohydrates != null) {
      parts.add(
        '${target.carbohydrates!.toInt()}g '
        '${l10n.nutrientCarbohydrates.toLowerCase()}',
      );
    }
    if (target.totalFat != null) {
      parts.add(
        '${target.totalFat!.toInt()}g '
        '${l10n.nutrientTotalFat.toLowerCase()}',
      );
    }
    return parts.join(' - ');
  }
}
