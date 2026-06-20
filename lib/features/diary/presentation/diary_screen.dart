import 'package:flutter/material.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The diary home (S-01): a day's logged entries grouped by meal slot.
///
/// This is the shell-level scaffold; the date stepper, totals bar, and entry
/// list arrive in a later increment. For now it shows the empty-day state.
class DiaryScreen extends StatelessWidget {
  /// Creates the diary screen.
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.diaryTitle)),
      body: EmptyState(
        icon: Icons.book_outlined,
        message: l10n.diaryEmptyMessage,
      ),
    );
  }
}
