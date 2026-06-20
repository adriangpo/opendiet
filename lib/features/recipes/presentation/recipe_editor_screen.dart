import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/core/widgets/food_picker_dialog.dart';
import 'package:opendiet/core/widgets/quantity_field.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/domain/recipe_nutrition.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The recipe editor screen (S-09, FR-015/FR-016).
///
/// [recipeId] is null for a new recipe, or the id of an existing recipe to
/// edit.
class RecipeEditorScreen extends ConsumerStatefulWidget {
  /// Creates a recipe editor, optionally editing [recipeId].
  const RecipeEditorScreen({this.recipeId, this.onSaved, super.key});

  /// The id of an existing recipe to edit, or null for a new one.
  final String? recipeId;

  /// Called after a successful save; null when saving independently.
  final VoidCallback? onSaved;

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _IngredientRow {
  _IngredientRow({required this.food, required this.quantity});

  Food food;
  Quantity quantity;

  String get foodId => food.id;
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  final _nameController = TextEditingController();
  final _yieldController = TextEditingController();
  final _ingredients = <_IngredientRow>[];
  String? _error;
  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _yieldController.text = '4';
    if (widget.recipeId != null) {
      unawaited(_loadRecipe());
    } else {
      _initialized = true;
    }
  }

  Future<void> _loadRecipe() async {
    final recipe = await ref
        .read(recipeRepositoryProvider)
        .findRecipe(widget.recipeId!);
    if (!mounted || recipe == null) return;
    final foods = await ref.read(foodRepositoryProvider).allFoods();
    if (!mounted) return;
    final foodMap = {for (final f in foods) f.id: f};
    setState(() {
      _nameController.text = recipe.name;
      _yieldController.text = recipe.yieldServings.toStringAsFixed(
        recipe.yieldServings == recipe.yieldServings.roundToDouble() ? 0 : 1,
      );
      _ingredients.clear();
      for (final ingredient in recipe.ingredients) {
        final food = foodMap[ingredient.foodId];
        if (food != null) {
          _ingredients.add(
            _IngredientRow(food: food, quantity: ingredient.quantity),
          );
        }
      }
      _initialized = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yieldController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.recipeId != null;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.recipeEditorErrorNameRequired);
      return;
    }
    final yieldText = _yieldController.text.trim();
    final yieldValue = double.tryParse(yieldText.replaceAll(',', '.'));
    if (yieldValue == null || !yieldValue.isFinite || yieldValue < 1) {
      setState(() => _error = l10n.recipeEditorErrorYield);
      return;
    }
    if (_ingredients.isEmpty) {
      setState(() => _error = l10n.recipeEditorErrorIngredients);
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    final now = ref.read(clockProvider).now();
    final existing = widget.recipeId != null
        ? await ref.read(recipeRepositoryProvider).findRecipe(widget.recipeId!)
        : null;
    if (!mounted) return;

    final recipe = Recipe(
      id: existing?.id ?? ref.read(idGeneratorProvider).newId(),
      name: name,
      yieldServings: yieldValue,
      ingredients: _ingredients
          .map(
            (row) =>
                RecipeIngredient(foodId: row.foodId, quantity: row.quantity),
          )
          .toList(),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await ref.read(recipeRepositoryProvider).saveRecipe(recipe);
    if (!mounted) return;
    widget.onSaved?.call();
  }

  Future<void> _addIngredient() async {
    final food = await FoodPickerDialog.show(context);
    if (food == null || !mounted) return;
    setState(() {
      _ingredients.add(
        _IngredientRow(food: food, quantity: Quantity.grams(100)),
      );
    });
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  void _updateQuantity(int index, Quantity? quantity) {
    if (quantity == null) return;
    setState(() => _ingredients[index].quantity = quantity);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final foodsAsync = ref.watch(foodListProvider);
    final foodMap = <String, Food>{};
    final allFoods = foodsAsync.asData?.value ?? <Food>[];
    for (final f in allFoods) {
      foodMap[f.id] = f;
    }

    Nutrients? totalNutrients;
    Nutrients? perServingNutrients;
    if (_ingredients.isNotEmpty) {
      final yieldText = _yieldController.text.trim();
      final yieldValue = double.tryParse(yieldText.replaceAll(',', '.'));
      final validYield =
          yieldValue != null && yieldValue.isFinite && yieldValue >= 1;
      final ingredients = _ingredients
          .map(
            (row) =>
                RecipeIngredient(foodId: row.foodId, quantity: row.quantity),
          )
          .toList();
      final hasAllFoods = ingredients.every((ingredient) {
        return foodMap.containsKey(ingredient.foodId);
      });
      if (hasAllFoods) {
        final recipe = Recipe(
          id: '',
          name: _nameController.text.trim(),
          yieldServings: yieldValue ?? 4,
          ingredients: ingredients,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        totalNutrients = RecipeNutrition.total(recipe, foodMap);
        if (validYield) {
          perServingNutrients = RecipeNutrition.perServing(recipe, foodMap);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.recipeEditorEditTitle : l10n.recipeEditorNewTitle,
        ),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: Text(l10n.actionSave),
          ),
        ],
      ),
      body: _initialized
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                TextField(
                  key: const Key('recipe-editor-name-field'),
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.recipeFieldName),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('recipe-editor-yield-field'),
                  controller: _yieldController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.recipeFieldYield,
                    suffixText: l10n.recipeFieldYieldSuffix,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.recipeIngredients,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                for (var i = 0; i < _ingredients.length; i++) ...[
                  _IngredientCard(
                    index: i,
                    ingredient: _ingredients[i],
                    onDelete: () => _removeIngredient(i),
                    onQuantityChanged: (q) => _updateQuantity(i, q),
                  ),
                  const SizedBox(height: 8),
                ],
                OutlinedButton.icon(
                  key: const Key('recipe-add-ingredient-button'),
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.recipeAddIngredient),
                ),
                if (totalNutrients != null) ...[
                  const SizedBox(height: 16),
                  _NutritionPreview(
                    totalNutrients: totalNutrients,
                    perServingNutrients: perServingNutrients,
                    l10n: l10n,
                  ),
                ],
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  const _IngredientCard({
    required this.index,
    required this.ingredient,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  final int index;
  final _IngredientRow ingredient;
  final VoidCallback onDelete;
  final ValueChanged<Quantity?> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ingredient.food.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  key: Key('recipe-delete-ingredient-$index'),
                  icon: const Icon(Icons.close),
                  tooltip: AppLocalizations.of(context).recipeDeleteIngredient,
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            QuantityField(
              unitSystem: UnitSystem.metric,
              hasServingSize:
                  ingredient.food.servingSizeMetric != null &&
                  ingredient.food.servingSizeMetric! > 0,
              initialValue: ingredient.quantity,
              onChanged: onQuantityChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionPreview extends StatelessWidget {
  const _NutritionPreview({
    required this.totalNutrients,
    required this.perServingNutrients,
    required this.l10n,
  });

  final Nutrients totalNutrients;
  final Nutrients? perServingNutrients;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final energyTotal = totalNutrients.energyKcal;
    final energyPerServing = perServingNutrients?.energyKcal;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recipeEditorComputedTotal(_formatKcal(energyTotal)),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (energyPerServing != null) ...[
            const SizedBox(height: 4),
            Text(_perServingText(l10n, energyPerServing)),
          ],
        ],
      ),
    );
  }

  String _formatKcal(double? value) {
    if (value == null) return '--';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  String _perServingText(AppLocalizations l10n, double energyPerServing) {
    final value = _formatKcal(energyPerServing);
    return '-> ${l10n.recipeEditorComputedPerServing(value)}';
  }
}
