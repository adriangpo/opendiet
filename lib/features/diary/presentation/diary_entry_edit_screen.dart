import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/presentation/food_quantity_entry_screen.dart';
import 'package:opendiet/features/diary/presentation/quick_add_screen.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Edit screen for an existing diary entry (S-04 edit mode).
///
/// Loads the entry by [entryId] and delegates to the appropriate edit form
/// based on its [DiaryReferenceKind]. Food entries open the quantity editor
/// pre-filled; quick-add entries open the quick-add form pre-filled.
class DiaryEntryEditScreen extends ConsumerWidget {
  /// Creates an edit screen for the diary entry with [entryId].
  const DiaryEntryEditScreen({
    required this.entryId,
    super.key,
  });

  /// The diary entry id to edit.
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(selectedDayEntriesProvider);

    return entriesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.diaryTitle)),
        body: const SizedBox.shrink(),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.diaryTitle)),
        body: Center(child: Text(l10n.diaryLoadError)),
      ),
      data: (entries) {
        final entry = entries.where((e) => e.id == entryId).firstOrNull;
        if (entry == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.diaryTitle)),
            body: Center(child: Text(l10n.diaryLoadError)),
          );
        }
        return _buildEditor(context, ref, l10n, entry);
      },
    );
  }

  Widget _buildEditor(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    DiaryEntry entry,
  ) {
    switch (entry.referenceKind) {
      case DiaryReferenceKind.food:
        final foodId = entry.referenceId;
        if (foodId == null) {
          return _fallback(context, l10n);
        }
        return FoodQuantityEntryScreen(
          foodId: foodId,
          day: entry.day,
          mealSlotId: entry.mealSlotId,
          existingEntry: entry,
        );
      case DiaryReferenceKind.quickAdd:
        return QuickAddScreen(
          slotId: entry.mealSlotId,
          day: entry.day,
          existingEntry: entry,
        );
      case DiaryReferenceKind.recipe:
        return _fallback(context, l10n);
    }
  }

  Scaffold _fallback(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.diaryTitle)),
      body: Center(child: Text(l10n.diaryLoadError)),
    );
  }
}
