import 'package:flutter/material.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_nutrition.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// A single food row for the catalog, search results, and recents (S-06).
///
/// Shows the food's name, its brand (when known), and its energy per 100 g/ml,
/// with a trailing action button the caller wires to log/favorite/etc. The
/// per-100 view is derived through [FoodNutrition.per100] so every food source
/// renders the same way (see .spec/design/ui/design-system.md).
class FoodListTile extends StatelessWidget {
  /// Creates a food row for [food]; [onAction] handles the trailing button.
  const FoodListTile({
    required this.food,
    required this.onAction,
    this.actionIcon = Icons.add,
    this.actionLabel,
    super.key,
  });

  /// The food to display.
  final Food food;

  /// Invoked when the trailing action button is pressed.
  final VoidCallback onAction;

  /// The icon for the trailing action button.
  final IconData actionIcon;

  /// The semantic label/tooltip for the trailing action button.
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final brand = food.brand;

    return ListTile(
      title: Text(
        food.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: brand == null ? null : Text(brand),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.foodEnergyPer100(_energyLabel(), _basisUnit(l10n)),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          IconButton(
            tooltip: actionLabel,
            onPressed: onAction,
            icon: Icon(actionIcon),
          ),
        ],
      ),
    );
  }

  /// The per-100 energy as a display string, or "--" when not informed.
  ///
  /// An absent value reads blank (a dash), never zero (FR-026 keeps
  /// "not informed" distinct from a real zero).
  String _energyLabel() {
    final energy = FoodNutrition.per100(food).energyKcal;
    if (energy == null) return '--';
    return energy == energy.roundToDouble()
        ? energy.toInt().toString()
        : energy.toStringAsFixed(1);
  }

  /// The g/ml abbreviation the per-100 value is expressed in.
  String _basisUnit(AppLocalizations l10n) => switch (food.basis) {
    NutrientBasis.per100g => l10n.servingUnitGram,
    NutrientBasis.per100ml => l10n.servingUnitMilliliter,
    NutrientBasis.perServing =>
      food.servingUnit == ServingUnit.milliliter
          ? l10n.servingUnitMilliliter
          : l10n.servingUnitGram,
  };
}
