import 'package:flutter/material.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The foods catalog (S-06). The list and create/import actions arrive in a
/// later increment; for now it shows the empty-catalog state.
class FoodsScreen extends StatelessWidget {
  /// Creates the foods screen.
  const FoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.foodsTitle)),
      body: EmptyState(
        icon: Icons.restaurant_outlined,
        message: l10n.foodsEmptyMessage,
      ),
    );
  }
}
