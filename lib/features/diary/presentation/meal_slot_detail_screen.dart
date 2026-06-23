import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/diary_totals.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// A meal slot's logged entries with a subtotal (FR-004).
class MealSlotDetailScreen extends ConsumerWidget {
  /// Creates a meal slot detail screen.
  const MealSlotDetailScreen({
    required this.mealSlotId,
    super.key,
  });

  /// The meal slot to show entries for.
  final String mealSlotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(selectedDayEntriesProvider);
    final slotsAsync = ref.watch(mealSlotsProvider);

    final values = slotsAsync.asData?.value;
    final slot = values?.where((s) => s.id == mealSlotId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(slot?.name ?? l10n.diaryLoadError),
      ),
      body: entriesAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => Center(child: Text(l10n.diaryLoadError)),
        data: (entries) {
          final slotEntries = entries
              .where((e) => e.mealSlotId == mealSlotId)
              .toList();
          if (slotEntries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.diarySlotNoEntries),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.push('/diary/add/$mealSlotId'),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.diaryAddToSlot(slot?.name ?? '')),
                  ),
                ],
              ),
            );
          }
          final slotTotals = DiaryTotals.forEntries(slotEntries);
          return _EntryList(
            entries: slotEntries,
            totals: slotTotals,
            l10n: l10n,
          );
        },
      ),
    );
  }
}

class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.entries,
    required this.totals,
    required this.l10n,
  });

  final List<DiaryEntry> entries;
  final Nutrients totals;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final entry in entries) _EntryRow(entry: entry, l10n: l10n),
        const Divider(height: 24),
        _TotalRow(totals: totals, l10n: l10n),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, required this.l10n});

  final DiaryEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final kcal = entry.nutrients.energyKcal;
    return ListTile(
      title: Text(entry.label),
      trailing: Text(
        kcal == null ? '--' : _formatKcal(kcal),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.totals, required this.l10n});

  final Nutrients totals;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.diarySlotTotal(_formatKcal(totals.energyKcal)),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

String _formatKcal(double? kcal) {
  if (kcal == null) return '--';
  final rounded = kcal.roundToDouble();
  return rounded == kcal ? rounded.toInt().toString() : kcal.toStringAsFixed(1);
}
