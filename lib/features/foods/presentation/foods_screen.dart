import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/widgets/empty_state.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The foods catalog (S-06).
class FoodsScreen extends ConsumerWidget {
  /// Creates the foods screen.
  const FoodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final foodsAsync = ref.watch(foodListProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.foodsTitle)),
      body: foodsAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => Center(child: Text(l10n.foodsLoadError)),
        data: (foods) {
          if (foods.isEmpty) {
            return EmptyState(
              icon: Icons.restaurant_outlined,
              message: l10n.foodsEmptyMessage,
            );
          }
          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) => _FoodListTile(food: foods[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/foods/new'),
        tooltip: l10n.foodEditorNewTitle,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FoodListTile extends StatelessWidget {
  const _FoodListTile({required this.food});

  final Food food;

  @override
  Widget build(BuildContext context) {
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
      trailing: Text(trailing),
    );
  }
}
