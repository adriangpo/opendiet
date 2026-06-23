import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/data/food_search_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The foods catalog (S-06).
class FoodsScreen extends ConsumerStatefulWidget {
  const FoodsScreen({super.key});

  @override
  ConsumerState<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends ConsumerState<FoodsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(foodSearchQueryProvider),
    )..addListener(_syncSearchQuery);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_syncSearchQuery)
      ..dispose();
    super.dispose();
  }

  void _syncSearchQuery() {
    final query = _searchController.text;
    final notifier = ref.read(foodSearchQueryProvider.notifier);
    if (ref.read(foodSearchQueryProvider) != query) {
      notifier.query = query;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchQuery = ref.watch(foodSearchQueryProvider);
    final resultsAsync = ref.watch(foodSearchResultsProvider);
    final sourceFilter = ref.watch(foodSourceFilterProvider);
    ref.listen(foodSearchQueryProvider, (_, next) {
      if (_searchController.text == next) return;
      _searchController.value = _searchController.value.copyWith(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
        composing: TextRange.empty,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.foodsTitle),
        actions: [
          IconButton(
            icon: const Icon(Boxicons.bx_qr),
            tooltip: l10n.foodsBarcodeScan,
            onPressed: () => context.push('/log/scan'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.foodsSearchHint,
                prefixIcon: const Icon(Boxicons.bx_search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Boxicons.bx_x_circle),
                        onPressed: _searchController.clear,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) =>
                  ref.read(foodSearchQueryProvider.notifier).query = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: l10n.foodsFilterMine,
                  selected: sourceFilter == FoodSourceFilter.mine,
                  onSelected: () =>
                      ref.read(foodSourceFilterProvider.notifier).filter =
                          FoodSourceFilter.mine,
                ),
                _FilterChip(
                  label: l10n.foodsFilterSavedFromOff,
                  selected: sourceFilter == FoodSourceFilter.savedFromOff,
                  onSelected: () =>
                      ref.read(foodSourceFilterProvider.notifier).filter =
                          FoodSourceFilter.savedFromOff,
                ),
                _FilterChip(
                  label: l10n.foodsFilterAll,
                  selected: sourceFilter == FoodSourceFilter.all,
                  onSelected: () =>
                      ref.read(foodSourceFilterProvider.notifier).filter =
                          FoodSourceFilter.all,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: resultsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => Center(child: Text(l10n.foodsLoadError)),
              data: (result) {
                final filtered = result.filterBySource(sourceFilter);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Boxicons.bx_food_menu,
                    message: l10n.foodsEmptyMessage,
                  );
                }
                return ListView.builder(
                  itemCount: filtered.all.length,
                  itemBuilder: (context, index) =>
                      _FoodListTile(food: filtered.all[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/foods/new'),
        tooltip: l10n.foodEditorNewTitle,
        child: const Icon(Boxicons.bx_plus),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

enum _FoodRowAction { log, favorite, edit, delete }

class _FoodListTile extends ConsumerWidget {
  const _FoodListTile({required this.food});

  final Food food;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final energyText = switch (food.nutrients.energyKcal) {
      null => '--',
      final v => v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1),
    };
    final trailing = switch (food.basis) {
      NutrientBasis.per100g => l10n.foodEnergyPer100(energyText, 'g'),
      NutrientBasis.per100ml => l10n.foodEnergyPer100(energyText, 'ml'),
      NutrientBasis.perServing => l10n.foodEnergyPerServing(energyText),
    };

    return ListTile(
      title: Text(food.name),
      subtitle: food.brand != null ? Text(food.brand!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing),
          PopupMenuButton<_FoodRowAction>(
            key: Key('food-row-menu-${food.id}'),
            tooltip: l10n.foodRowMenuTooltip,
            onSelected: (action) => unawaited(
              _handleAction(context, ref, action),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                key: Key('food-row-log-${food.id}'),
                value: _FoodRowAction.log,
                child: Text(l10n.foodActionLog),
              ),
              PopupMenuItem(
                key: Key('food-row-favorite-${food.id}'),
                value: _FoodRowAction.favorite,
                child: Text(
                  food.isFavorite
                      ? l10n.foodActionUnfavorite
                      : l10n.foodActionFavorite,
                ),
              ),
              PopupMenuItem(
                key: Key('food-row-edit-${food.id}'),
                value: _FoodRowAction.edit,
                child: Text(l10n.foodActionEdit),
              ),
              PopupMenuItem(
                key: Key('food-row-delete-${food.id}'),
                value: _FoodRowAction.delete,
                child: Text(l10n.foodActionDelete),
              ),
            ],
          ),
        ],
      ),
      onTap: () => context.push('/foods/${Uri.encodeComponent(food.id)}'),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _FoodRowAction action,
  ) async {
    switch (action) {
      case _FoodRowAction.log:
        unawaited(
          context.push('/log/quantity/food:${Uri.encodeComponent(food.id)}'),
        );
      case _FoodRowAction.favorite:
        await ref.read(foodRepositoryProvider).toggleFavorite(food.id);
        _refreshFoods(ref);
      case _FoodRowAction.edit:
        unawaited(context.push('/foods/${Uri.encodeComponent(food.id)}/edit'));
      case _FoodRowAction.delete:
        await _confirmAndDelete(context, ref);
    }
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.foodDeleteConfirmTitle),
        content: Text(l10n.foodDeleteConfirmMessage(food.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.foodDeleteConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(foodRepositoryProvider).deleteFood(food.id);
      _refreshFoods(ref);
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.foodDeleteError)),
      );
    }
  }

  void _refreshFoods(WidgetRef ref) {
    ref
      ..invalidate(foodSearchResultsProvider)
      ..invalidate(foodListProvider)
      ..invalidate(recentFoodsProvider)
      ..invalidate(favoriteFoodsProvider);
  }
}
