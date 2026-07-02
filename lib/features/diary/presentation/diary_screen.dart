import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/core/widgets/nutrient_totals_bar.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_day_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/diary_totals.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/diary/presentation/diary_entry_row.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The diary home (S-01): a day's logged entries grouped by meal slot.
class DiaryScreen extends ConsumerWidget {
  /// Creates the diary screen.
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final slotsAsync = ref.watch(mealSlotsProvider);
    final entriesAsync = ref.watch(selectedDayEntriesProvider);
    final selectedDay = ref.watch(diaryDayProvider);
    final dailyTarget = ref
        .watch(settingsControllerProvider)
        .asData
        ?.value
        .dailyTarget;

    return Scaffold(
      appBar: AppBar(
        title: _DateStepper(
          selectedDay: selectedDay,
          l10n: l10n,
          onPrevious: () => ref.read(diaryDayProvider.notifier).previousDay(),
          onNext: () => ref.read(diaryDayProvider.notifier).nextDay(),
          onToday: () => ref.read(diaryDayProvider.notifier).goToToday(),
        ),
        centerTitle: true,
      ),
      body: slotsAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => Center(child: Text(l10n.diaryLoadError)),
        data: (slots) {
          if (slots.isEmpty) {
            return EmptyState(
              icon: Boxicons.bx_book_alt,
              message: l10n.diaryEmptyMessage,
            );
          }
          return entriesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => Center(child: Text(l10n.diaryLoadError)),
            data: (entries) => _DiaryContent(
              slots: slots,
              entries: entries,
              dailyTarget: dailyTarget,
              l10n: l10n,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (slotsAsync.hasValue && slotsAsync.value!.isNotEmpty) {
            unawaited(
              context.push(
                '/diary/add/${slotsAsync.value!.first.id}',
              ),
            );
          }
        },
        tooltip: l10n.addLogHubTitle,
        child: const Icon(Boxicons.bx_plus),
      ),
    );
  }
}

class _DiaryContent extends StatelessWidget {
  const _DiaryContent({
    required this.slots,
    required this.entries,
    required this.dailyTarget,
    required this.l10n,
  });

  final List<MealSlot> slots;
  final List<DiaryEntry> entries;
  final Nutrients? dailyTarget;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final dayTotals = DiaryTotals.forEntries(entries);
    final entriesBySlot = <String, List<DiaryEntry>>{};
    for (final entry in entries) {
      entriesBySlot.putIfAbsent(entry.mealSlotId, () => []).add(entry);
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: NutrientTotalsBar(
            totals: dayTotals,
            target: dailyTarget,
          ),
        ),
        for (final slot in slots) ...[
          _MealSlotSection(
            slot: slot,
            entries: entriesBySlot[slot.id] ?? [],
            l10n: l10n,
          ),
          const Divider(height: 1),
        ],
      ],
    );
  }
}

/// A compact date stepper with previous/next arrows and a Today button.
class _DateStepper extends StatelessWidget {
  const _DateStepper({
    required this.selectedDay,
    required this.l10n,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime selectedDay;
  final AppLocalizations l10n;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dayLabel = DateFormat.MMMd(locale).format(selectedDay);
    final weekdayLabel = DateFormat.E(locale).format(selectedDay);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Boxicons.bx_chevron_left),
          onPressed: onPrevious,
          tooltip: l10n.diaryPreviousDay,
        ),
        GestureDetector(
          onTap: onToday,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weekdayLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                dayLabel,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Boxicons.bx_chevron_right),
          onPressed: onNext,
          tooltip: l10n.diaryNextDay,
        ),
        TextButton(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onPressed: onToday,
          child: Text(l10n.diaryToday),
        ),
      ],
    );
  }
}

class _MealSlotSection extends ConsumerWidget {
  const _MealSlotSection({
    required this.slot,
    required this.entries,
    required this.l10n,
  });

  final MealSlot slot;
  final List<DiaryEntry> entries;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final slotTotals = DiaryTotals.forEntries(entries);
    final slotKcal = slotTotals.energyKcal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  slot.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _slotKcalText(slotKcal, l10n),
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.diarySlotNoEntries,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final entry in entries)
            DiaryEntryRow(
              entry: entry,
              onTap: () => _editEntry(context, entry),
              onDelete: () => _deleteEntry(ref, entry),
            ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextButton.icon(
            onPressed: () => context.push('/diary/add/${slot.id}'),
            icon: const Icon(Boxicons.bx_plus, size: 18),
            label: Text(l10n.diarySlotAddLabel(slot.name)),
          ),
        ),
      ],
    );
  }

  void _editEntry(BuildContext context, DiaryEntry entry) {
    unawaited(context.push('/diary/entry/${entry.id}/edit'));
  }

  Future<void> _deleteEntry(WidgetRef ref, DiaryEntry entry) async {
    await ref.read(diaryRepositoryProvider).deleteEntry(entry.id);
    ref.read(diaryMutationProvider.notifier).touch();
  }
}

String _slotKcalText(double? kcal, AppLocalizations l10n) {
  if (kcal == null) return '--';
  final rounded = kcal.roundToDouble();
  final number = rounded == kcal
      ? rounded.toInt().toString()
      : kcal.toStringAsFixed(1);
  return '$number ${l10n.unitKilocalorie}';
}
