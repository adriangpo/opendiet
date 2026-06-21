import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/core/widgets/nutrition_table_br.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/presentation/custom_food_editor.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Saved-food detail screen (S-07).
class FoodDetailScreen extends ConsumerWidget {
  /// Creates the detail screen for a saved food id.
  const FoodDetailScreen({
    required this.foodId,
    this.onEdit,
    this.onLog,
    this.onSuggestCorrection,
    super.key,
  });

  /// The saved food id.
  final String foodId;

  /// Optional edit entry point, used by tests or custom hosts.
  final VoidCallback? onEdit;

  /// Optional log entry point, used by tests or custom hosts.
  final VoidCallback? onLog;

  /// Optional OFF correction entry point, used by tests or custom hosts.
  final VoidCallback? onSuggestCorrection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final foods = ref.watch(foodListProvider);
    final settings =
        ref.watch(settingsControllerProvider).asData?.value ??
        AppSettings.defaults;

    return foods.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.foodsTitle)),
        body: const SizedBox.shrink(),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.foodsTitle)),
        body: Center(child: Text(l10n.foodsLoadError)),
      ),
      data: (items) {
        final food = items.where((item) => item.id == foodId).firstOrNull;
        if (food == null) return _NotFoundScreen(l10n: l10n);
        return Scaffold(
          appBar: AppBar(
            title: Text(food.name),
            actions: [
              IconButton(
                key: const Key('food-detail-favorite-button'),
                tooltip: food.isFavorite
                    ? l10n.foodDetailFavoriteRemove
                    : l10n.foodDetailFavoriteAdd,
                icon: Icon(
                  food.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () =>
                    ref.read(foodRepositoryProvider).toggleFavorite(food.id),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _FoodMetadata(food: food),
              const SizedBox(height: 16),
              NutritionTableBR.forFood(
                food: food,
                vdRegion: settings.vdRegion,
                unitSystem: settings.unitSystem,
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('food-detail-log-button'),
                onPressed: onLog ?? () => _openLog(context, food),
                child: Text(l10n.foodDetailLogFood),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                key: const Key('food-detail-edit-button'),
                onPressed: onEdit ?? () => _openEdit(context, food),
                child: Text(l10n.foodDetailEdit),
              ),
              if (food.source == FoodSource.openFoodFacts) ...[
                const SizedBox(height: 8),
                TextButton(
                  key: const Key('food-detail-correction-button'),
                  onPressed:
                      onSuggestCorrection ??
                      () => context.push('/settings/account'),
                  child: Text(l10n.foodDetailSuggestCorrection),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _openEdit(BuildContext context, Food food) {
    unawaited(context.push('/foods/${Uri.encodeComponent(food.id)}/edit'));
  }

  void _openLog(BuildContext context, Food food) {
    unawaited(
      context.push('/log/quantity/food:${Uri.encodeComponent(food.id)}'),
    );
  }
}

/// Loads a saved food and hosts the editor for `/foods/:id/edit`.
class FoodEditScreen extends ConsumerWidget {
  /// Creates the edit host for [foodId].
  const FoodEditScreen({required this.foodId, super.key});

  /// The saved food id.
  final String foodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final foods = ref.watch(foodListProvider);
    return foods.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.foodEditorEditTitle)),
        body: Center(child: Text(l10n.foodsLoadError)),
      ),
      data: (items) {
        final food = items.where((item) => item.id == foodId).firstOrNull;
        if (food == null) return _NotFoundScreen(l10n: l10n);
        return CustomFoodEditor(
          initialFood: food,
          onSaved: (_) => context.pop(),
        );
      },
    );
  }
}

class _FoodMetadata extends StatelessWidget {
  const _FoodMetadata({required this.food});

  final Food food;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final brand = food.brand;
    final source = _sourceLabel(l10n, food.source);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (brand != null && brand.trim().isNotEmpty)
          Text(l10n.foodDetailBrand(brand)),
        if (source != null) Text(l10n.foodDetailSource(source)),
      ],
    );
  }

  String? _sourceLabel(AppLocalizations l10n, FoodSource source) =>
      switch (source) {
        FoodSource.custom => null,
        FoodSource.openFoodFacts => l10n.foodSourceOpenFoodFacts,
        FoodSource.imported => l10n.foodSourceImported,
      };
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.foodsTitle)),
      body: EmptyState(
        icon: Icons.restaurant_outlined,
        message: l10n.foodDetailNotFound,
      ),
    );
  }
}
