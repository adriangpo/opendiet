import 'package:flutter/material.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The recipes list (S-08). The list and editor arrive in a later increment;
/// for now it shows the empty-list state.
class RecipesScreen extends StatelessWidget {
  /// Creates the recipes screen.
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recipesTitle)),
      body: EmptyState(
        icon: Icons.menu_book_outlined,
        message: l10n.recipesEmptyMessage,
      ),
    );
  }
}
