import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Hosts the primary bottom navigation across the four top-level tabs (Diary,
/// Foods, Recipes, Settings) and renders the active branch (see
/// .spec/design/ui/design-system.md).
class AppScaffold extends StatelessWidget {
  /// Creates the shell around [navigationShell].
  const AppScaffold({required this.navigationShell, super.key});

  /// The go_router stateful shell that tracks and renders the active branch.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.book_outlined),
            selectedIcon: const Icon(Icons.book),
            label: l10n.navDiary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_outlined),
            selectedIcon: const Icon(Icons.restaurant),
            label: l10n.navFoods,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.navRecipes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }

  void _goBranch(int index) => navigationShell.goBranch(
    index,
    // Re-tapping the active tab returns it to its initial route.
    initialLocation: index == navigationShell.currentIndex,
  );
}
