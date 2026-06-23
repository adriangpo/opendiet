import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/domain/recipe_nutrition.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The recipes list screen (S-08, FR-015).
class RecipesScreen extends ConsumerWidget {
  /// Creates the recipes screen.
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recipesAsync = ref.watch(recipeListProvider);
    final foodsAsync = ref.watch(foodListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recipesTitle)),
      body: recipesAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
        data: (recipes) {
          if (recipes.isEmpty) {
            return EmptyState(
              icon: Boxicons.bx_book_open,
              message: l10n.recipesEmptyMessage,
            );
          }
          final foods = foodsAsync.asData?.value ?? <Food>[];
          final foodMap = <String, Food>{for (final f in foods) f.id: f};
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) => _RecipeListTile(
              recipe: recipes[index],
              foodMap: foodMap,
              l10n: l10n,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/recipes/new'),
        tooltip: l10n.recipeEditorNewTitle,
        child: const Icon(Boxicons.bx_plus),
      ),
    );
  }
}

class _RecipeListTile extends StatelessWidget {
  const _RecipeListTile({
    required this.recipe,
    required this.foodMap,
    required this.l10n,
  });

  final Recipe recipe;
  final Map<String, Food> foodMap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    Nutrients? perServing;
    final hasAllFoods = recipe.ingredients.every((ingredient) {
      return foodMap.containsKey(ingredient.foodId);
    });
    if (hasAllFoods) {
      perServing = RecipeNutrition.perServing(recipe, foodMap);
    }
    final energyText = switch (perServing?.energyKcal) {
      null => '--',
      final v => v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1),
    };

    return ListTile(
      title: Text(recipe.name),
      subtitle: Text(
        l10n.recipeServes(_formatServingCount(recipe.yieldServings)),
      ),
      trailing: Text(l10n.recipeEnergyPerServing(energyText)),
      onTap: () => context.push('/recipes/${recipe.id}'),
    );
  }

  String _formatServingCount(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}
