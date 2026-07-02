import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/features/foods/presentation/barcode_scanner_screen.dart';
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
      bottomNavigationBar: _CustomBottomBar(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        onFabTap: () => _showQuickActions(context),
        destinations: [
          _BarDestination(
            icon: Boxicons.bx_book_alt,
            selectedIcon: Boxicons.bxs_book_alt,
            label: l10n.navDiary,
          ),
          _BarDestination(
            icon: Boxicons.bx_food_menu,
            selectedIcon: Boxicons.bxs_food_menu,
            label: l10n.navFoods,
          ),
          _BarDestination(
            icon: Boxicons.bx_book_open,
            selectedIcon: Boxicons.bxs_book_open,
            label: l10n.navRecipes,
          ),
          _BarDestination(
            icon: Boxicons.bx_cog,
            selectedIcon: Boxicons.bxs_cog,
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }

  Future<void> _showQuickActions(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionTile(
                icon: Boxicons.bx_qr,
                label: l10n.quickActionScanBarcode,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const BarcodeScannerScreen(),
                    ),
                  );
                },
              ),
              _ActionTile(
                icon: Boxicons.bx_plus_circle,
                label: l10n.quickActionNewFood,
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(context.push('/foods/new'));
                },
              ),
              _ActionTile(
                icon: Boxicons.bx_book_open,
                label: l10n.quickActionNewRecipe,
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(context.push('/recipes/new'));
                },
              ),
              _ActionTile(
                icon: Boxicons.bx_bolt_circle,
                label: l10n.quickActionQuickAdd,
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(context.push('/log'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );
}

class _BarDestination {
  const _BarDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _CustomBottomBar extends StatelessWidget {
  const _CustomBottomBar({
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onFabTap,
    required this.destinations,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onFabTap;
  final List<_BarDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: _BarItem(
                  key: const ValueKey('nav-diary'),
                  icon: destinations[0].icon,
                  selectedIcon: destinations[0].selectedIcon,
                  label: destinations[0].label,
                  selected: currentIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
              ),
              Expanded(
                child: _BarItem(
                  key: const ValueKey('nav-foods'),
                  icon: destinations[1].icon,
                  selectedIcon: destinations[1].selectedIcon,
                  label: destinations[1].label,
                  selected: currentIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
              ),
              _CenterFabButton(onTap: onFabTap),
              Expanded(
                child: _BarItem(
                  key: const ValueKey('nav-recipes'),
                  icon: destinations[2].icon,
                  selectedIcon: destinations[2].selectedIcon,
                  label: destinations[2].label,
                  selected: currentIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
              ),
              Expanded(
                child: _BarItem(
                  key: const ValueKey('nav-settings'),
                  icon: destinations[3].icon,
                  selectedIcon: destinations[3].selectedIcon,
                  label: destinations[3].label,
                  selected: currentIndex == 3,
                  onTap: () => onDestinationSelected(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterFabButton extends StatelessWidget {
  const _CenterFabButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Transform.translate(
      offset: const Offset(0, -8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Boxicons.bx_plus, size: 22, color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconWidget = Icon(
      selected ? selectedIcon : icon,
      size: 20,
      color: selected
          ? colorScheme.onSecondaryContainer
          : colorScheme.onSurfaceVariant,
    );
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.secondaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(height: 2),
              SizedBox(
                width: 54,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(label),
      onTap: onTap,
    );
  }
}
