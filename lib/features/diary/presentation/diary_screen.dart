import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
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
    final today = ref.read(clockProvider).now();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.diaryTitle)),
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
            itemBuilder: (context, index) => _MealSlotSection(
              slot: slots[index],
              l10n: l10n,
              today: today,
            ),
          );
        },
      ),
    );
  }
}

class _MealSlotSection extends StatelessWidget {
  const _MealSlotSection({
    required this.slot,
    required this.l10n,
    required this.today,
  });

  final MealSlot slot;
  final AppLocalizations l10n;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final dateStr = today.toIso8601String().split('T').first;
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
            onPressed: () => context.go('/log?slot=${slot.id}&date=$dateStr'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.diaryAddToSlot(slot.name)),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
