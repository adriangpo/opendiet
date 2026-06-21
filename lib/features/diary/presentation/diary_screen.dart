import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_day_providers.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The diary home (S-01): a day's logged entries grouped by meal slot.
class DiaryScreen extends ConsumerWidget {
  /// Creates the diary screen.
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final slotsAsync = ref.watch(mealSlotsProvider);
    final selectedDay = ref.watch(diaryDayProvider);

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
              icon: Icons.book_outlined,
              message: l10n.diaryEmptyMessage,
            );
          }
          return ListView.builder(
            itemCount: slots.length,
            itemBuilder: (context, index) =>
                _MealSlotSection(slot: slots[index], l10n: l10n),
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
        child: const Icon(Icons.add),
      ),
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
          icon: const Icon(Icons.chevron_left),
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
          icon: const Icon(Icons.chevron_right),
          onPressed: onNext,
          tooltip: l10n.diaryNextDay,
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: onToday,
          child: Text(l10n.diaryToday),
        ),
      ],
    );
  }
}

class _MealSlotSection extends StatelessWidget {
  const _MealSlotSection({
    required this.slot,
    required this.l10n,
  });

  final MealSlot slot;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            slot.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton.icon(
            onPressed: () => context.push('/diary/add/${slot.id}'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.diaryAddToSlot(slot.name)),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
