import 'package:flutter/material.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/diary/domain/diary_totals.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Summary of a day's energy and macro totals against an optional daily target
/// (FR-004, FR-022; see .spec/design/ui/design-system.md).
///
/// Energy leads, followed by protein, carbohydrates, and total fat. When a
/// [target] sets a value for a nutrient, the row also shows how much is left or
/// how far it is over, computed by [DailyTargetComparison.remaining]. The
/// over-target state uses the error role paired with text and an icon, never
/// color alone. With no target, only the totals are shown.
class NutrientTotalsBar extends StatelessWidget {
  /// Creates a totals bar for [totals], optionally compared to [target].
  const NutrientTotalsBar({required this.totals, this.target, super.key});

  /// The day's summed nutrition.
  final Nutrients totals;

  /// The user's daily target, or null when none is set.
  final Nutrients? target;

  /// The headline nutrient followed by the three macros, in display order.
  static const List<Nutrient> _nutrients = [
    Nutrient.energy,
    Nutrient.protein,
    Nutrient.carbohydrates,
    Nutrient.totalFat,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NutrientRow(
              nutrient: Nutrient.energy,
              totals: totals,
              target: target,
              isHeadline: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final nutrient in _nutrients.skip(1))
                  Expanded(
                    child: _NutrientRow(
                      nutrient: nutrient,
                      totals: totals,
                      target: target,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One nutrient line: label, consumed amount, and optional remaining/over chip.
class _NutrientRow extends StatelessWidget {
  const _NutrientRow({
    required this.nutrient,
    required this.totals,
    required this.target,
    this.isHeadline = false,
  });

  final Nutrient nutrient;
  final Nutrients totals;
  final Nutrients? target;
  final bool isHeadline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final unit = _unitLabel(l10n, nutrient.unit);
    final consumed = totals.amountOf(nutrient) ?? 0;
    final remaining = DailyTargetComparison.remaining(totals, target, nutrient);

    final valueStyle = isHeadline
        ? theme.textTheme.titleLarge
        : theme.textTheme.titleMedium;
    final labelStyle =
        (isHeadline ? theme.textTheme.labelLarge : theme.textTheme.labelMedium)
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Column(
      key: Key('totals-row-${nutrient.name}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_nutrientLabel(l10n, nutrient), style: labelStyle),
        Text('${_format(consumed)} $unit', style: valueStyle),
        if (remaining != null)
          _ComparisonChip(remaining: remaining, unit: unit),
      ],
    );
  }
}

/// The remaining-or-over indicator for a nutrient with a target.
///
/// Uses the primary role while on or under target and the error role plus a
/// warning icon when over, so the over state never relies on color alone.
class _ComparisonChip extends StatelessWidget {
  const _ComparisonChip({required this.remaining, required this.unit});

  final double remaining;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isOver = remaining < 0;
    final amount = '${_format(remaining.abs())} $unit';
    final color = isOver ? theme.colorScheme.error : theme.colorScheme.primary;
    final text = isOver
        ? l10n.nutrientTotalsOver(amount)
        : l10n.nutrientTotalsRemaining(amount);
    final style = theme.textTheme.bodySmall?.copyWith(color: color);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isOver) ...[
          Icon(Icons.warning_amber_rounded, size: 16, color: color),
          const SizedBox(width: 4),
        ],
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}

/// Formats a nutrient amount: whole numbers plain, otherwise one decimal.
String _format(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);

String _nutrientLabel(AppLocalizations l10n, Nutrient nutrient) =>
    switch (nutrient) {
      Nutrient.energy => l10n.nutrientEnergy,
      Nutrient.carbohydrates => l10n.nutrientCarbohydrates,
      Nutrient.totalSugars => l10n.nutrientTotalSugars,
      Nutrient.addedSugars => l10n.nutrientAddedSugars,
      Nutrient.protein => l10n.nutrientProtein,
      Nutrient.totalFat => l10n.nutrientTotalFat,
      Nutrient.saturatedFat => l10n.nutrientSaturatedFat,
      Nutrient.transFat => l10n.nutrientTransFat,
      Nutrient.dietaryFiber => l10n.nutrientDietaryFiber,
      Nutrient.sodium => l10n.nutrientSodium,
    };

String _unitLabel(AppLocalizations l10n, NutrientUnit unit) => switch (unit) {
  NutrientUnit.kilocalorie => l10n.unitKilocalorie,
  NutrientUnit.gram => l10n.unitGram,
  NutrientUnit.milligram => l10n.unitMilligram,
};
