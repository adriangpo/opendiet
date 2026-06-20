import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/domain/recipe_nutrition.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The recipe detail screen (S-10, FR-016/FR-017).
class RecipeDetailScreen extends ConsumerWidget {
  /// Creates a recipe detail screen for [recipeId].
  const RecipeDetailScreen({required this.recipeId, this.onEdit, super.key});

  /// The id of the recipe to display.
  final String recipeId;

  /// Called when the user taps Edit; null when editing is not available.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recipeAsync = ref.watch(recipeByIdProvider(recipeId));
    final foodsAsync = ref.watch(foodListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeAsync.asData?.value?.name ?? ''),
        actions: [
          TextButton(
            key: const Key('recipe-detail-edit-button'),
            onPressed: onEdit,
            child: Text(l10n.recipeDetailEdit),
          ),
        ],
      ),
      body: recipeAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
        data: (recipe) {
          if (recipe == null) {
            return const SizedBox.shrink();
          }
          final foods = foodsAsync.asData?.value ?? <Food>[];
          final foodMap = <String, Food>{for (final f in foods) f.id: f};
          Nutrients? perServingNutrients;
          Nutrients? totalNutrients;
          if (_hasAllRecipeFoods(recipe, foodMap)) {
            totalNutrients = RecipeNutrition.total(recipe, foodMap);
            perServingNutrients = RecipeNutrition.perServing(recipe, foodMap);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.recipeServes(recipe.yieldServings.toStringAsFixed(0)),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (perServingNutrients != null) ...[
                Text(
                  l10n.recipeDetailPerServingTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                _nutrientLine(
                  l10n.nutrientEnergy,
                  _formatKcal(perServingNutrients.energyKcal),
                  'kcal',
                ),
                const SizedBox(height: 8),
              ],
              if (totalNutrients != null) ...[
                Text(
                  l10n.recipeDetailTotalTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                _nutrientLine(
                  l10n.nutrientEnergy,
                  _formatKcal(totalNutrients.energyKcal),
                  'kcal',
                ),
                const SizedBox(height: 16),
              ],
              Text(
                l10n.recipeDetailIngredients,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              for (final ingredient in recipe.ingredients) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    foodMap[ingredient.foodId]?.name ?? ingredient.foodId,
                  ),
                  trailing: Text(_formatQuantity(ingredient.quantity)),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const Key('recipe-detail-log-button'),
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: Text(l10n.recipeDetailLogServings),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _nutrientLine(String label, String value, String unit) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(label), Text('$value $unit')],
  );

  String _formatKcal(double? value) {
    if (value == null) return '--';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  String _formatQuantity(Quantity q) {
    final display = q.amount == q.amount.roundToDouble()
        ? q.amount.toInt().toString()
        : q.amount.toStringAsFixed(1);
    return switch (q.measure) {
      QuantityMeasure.grams => '$display g',
      QuantityMeasure.milliliters => '$display ml',
      QuantityMeasure.servings => '$display serving(s)',
    };
  }

  bool _hasAllRecipeFoods(
    Recipe recipe,
    Map<String, Food> foodMap,
  ) => recipe.ingredients.every((ingredient) {
    return foodMap.containsKey(ingredient.foodId);
  });
}
