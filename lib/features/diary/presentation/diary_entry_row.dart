import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// A diary entry row with tap-to-edit and swipe-to-delete (S-01).
///
/// Shows the entry label and its energy (kcal). Swiping left reveals a
/// confirmation dialog; confirming fires [onDelete] and shows an undo
/// snackbar. Tapping fires [onTap] for navigation to the edit screen.
class DiaryEntryRow extends ConsumerWidget {
  /// Creates a diary entry row.
  const DiaryEntryRow({
    required this.entry,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// The diary entry to display.
  final DiaryEntry entry;

  /// Called when the user taps the row (edit).
  final VoidCallback onTap;

  /// Called when the user confirms deletion.
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kcal = entry.nutrients.energyKcal;
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: theme.colorScheme.error,
        child: Icon(
          Boxicons.bx_trash,
          color: theme.colorScheme.onError,
        ),
      ),
      confirmDismiss: (direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.diaryEntryDeleteTitle),
            content: Text(l10n.diaryEntryDeleteMessage(entry.label)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.actionCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.actionDelete),
              ),
            ],
          ),
        );
        if (confirmed != true) return false;
        await onDelete();
        if (!context.mounted) return true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.diaryEntryDeleted(entry.label)),
            action: SnackBarAction(
              label: l10n.actionUndo,
              onPressed: () {
                unawaited(
                  ref.read(diaryRepositoryProvider).saveEntry(entry),
                );
                ref.read(diaryMutationProvider.notifier).touch();
              },
            ),
          ),
        );
        return true;
      },
      child: ListTile(
        dense: true,
        title: Text(entry.label),
        trailing: Text(
          kcal == null ? '--' : _formatKcal(context, kcal),
          style: theme.textTheme.bodyMedium,
        ),
        onTap: onTap,
      ),
    );
  }
}

String _formatKcal(BuildContext context, double kcal) {
  final rounded = kcal.roundToDouble();
  final number = rounded == kcal
      ? rounded.toInt().toString()
      : kcal.toStringAsFixed(1);
  final l10n = AppLocalizations.of(context);
  return '$number ${l10n.unitKilocalorie}';
}
