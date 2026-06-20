import 'package:flutter/material.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/units/unit_conversions.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_nutrition.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The universal ANVISA nutrition table (FR-026, FR-027).
///
/// Renders the ten mandatory nutrients in label order across three columns:
/// per 100 g/ml, per serving (with the household measure), and %VD for the
/// selected [vdRegion]. A nutrient the source did not provide reads "not
/// informed", never zero; a nutrient with no reference value in the region
/// (trans fat everywhere) shows no %VD.
class NutritionTableBR extends StatelessWidget {
  /// Creates the table from already-resolved per-100 and per-serving profiles.
  ///
  /// Either profile may be null when it cannot be derived (e.g. per serving
  /// when the food has no serving size); its cells then read "not informed".
  /// [isLiquid] selects the per-100 basis unit (ml vs g) and the serving-size
  /// unit family; [servingSizeMetric] is canonical metric (grams or
  /// milliliters) and is converted to [unitSystem] only for display (FR-024).
  const NutritionTableBR({
    required this.per100,
    required this.perServing,
    required this.isLiquid,
    required this.servingSizeMetric,
    required this.householdMeasure,
    required this.vdRegion,
    required this.unitSystem,
    super.key,
  });

  /// Builds the table for [food], computing both column profiles safely.
  factory NutritionTableBR.forFood({
    required Food food,
    required VdRegion vdRegion,
    required UnitSystem unitSystem,
    Key? key,
  }) {
    final size = food.servingSizeMetric;
    final hasServingSize = size != null && size > 0;
    final per100 = switch (food.basis) {
      NutrientBasis.per100g ||
      NutrientBasis.per100ml => FoodNutrition.per100(food),
      NutrientBasis.perServing =>
        hasServingSize ? FoodNutrition.per100(food) : null,
    };
    final perServing = switch (food.basis) {
      NutrientBasis.perServing => FoodNutrition.perServing(food),
      NutrientBasis.per100g || NutrientBasis.per100ml =>
        hasServingSize ? FoodNutrition.perServing(food) : null,
    };
    final isLiquid = switch (food.basis) {
      NutrientBasis.per100ml => true,
      NutrientBasis.per100g => false,
      NutrientBasis.perServing => food.servingUnit == ServingUnit.milliliter,
    };
    return NutritionTableBR(
      per100: per100,
      perServing: perServing,
      isLiquid: isLiquid,
      servingSizeMetric: food.servingSizeMetric,
      householdMeasure: food.householdMeasure,
      vdRegion: vdRegion,
      unitSystem: unitSystem,
      key: key,
    );
  }

  /// The food's nutrition per 100 g/ml, or null when it cannot be derived.
  final Nutrients? per100;

  /// The food's nutrition for one serving, or null when it cannot be derived.
  final Nutrients? perServing;

  /// Whether the per-100 basis and serving size are volumetric (ml) not mass.
  final bool isLiquid;

  /// One serving in canonical metric (grams or milliliters), or null.
  final double? servingSizeMetric;

  /// The household measure for one serving (e.g. "2 unidades"), or null.
  final String? householdMeasure;

  /// The region whose %VD reference set drives the %VD column.
  final VdRegion vdRegion;

  /// The unit system the serving size is displayed in (FR-024).
  final UnitSystem unitSystem;

  /// Sub-nutrients indented under their parent in the ANVISA layout.
  static const Set<Nutrient> _indented = {
    Nutrient.totalSugars,
    Nutrient.addedSugars,
    Nutrient.saturatedFat,
    Nutrient.transFat,
  };

  static const String _noReference = '-';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final references = VdReference.forRegion(vdRegion);
    final servingDescriptor = _servingDescriptor(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.nutritionTableTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1.6),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(0.8),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _headerRow(l10n, theme, servingDescriptor),
            for (final nutrient in Nutrient.values)
              _nutrientRow(l10n, theme, references, nutrient),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.settingsVdRegion}: ${_regionName(l10n)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  TableRow _headerRow(
    AppLocalizations l10n,
    ThemeData theme,
    String? servingDescriptor,
  ) {
    final style = theme.textTheme.titleSmall;
    final unit = isLiquid ? l10n.servingUnitMilliliter : l10n.servingUnitGram;
    return TableRow(
      children: [
        const SizedBox.shrink(),
        _headerCell(
          Text(
            l10n.nutritionTableHeaderPer100(unit),
            textAlign: TextAlign.end,
            style: style,
          ),
        ),
        _headerCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.nutritionTableHeaderServing,
                textAlign: TextAlign.end,
                style: style,
              ),
              if (servingDescriptor != null)
                Text(
                  servingDescriptor,
                  key: const Key('nutrition-serving-descriptor'),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        _headerCell(
          Text(
            l10n.nutritionTablePercentVd,
            textAlign: TextAlign.end,
            style: style,
          ),
        ),
      ],
    );
  }

  TableRow _nutrientRow(
    AppLocalizations l10n,
    ThemeData theme,
    VdReferenceSet references,
    Nutrient nutrient,
  ) {
    final indent = _indented.contains(nutrient) ? 16.0 : 0.0;
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(indent, 6, 4, 6),
          child: Text(_nutrientLabel(l10n, nutrient)),
        ),
        _valueCell(
          Key('nutrition-${nutrient.name}-per100'),
          _amountText(l10n, per100, nutrient),
        ),
        _valueCell(
          Key('nutrition-${nutrient.name}-perServing'),
          _amountText(l10n, perServing, nutrient),
        ),
        _valueCell(
          Key('nutrition-${nutrient.name}-vd'),
          _percentText(references, nutrient),
        ),
      ],
    );
  }

  Widget _headerCell(Widget child) =>
      Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 8), child: child);

  Widget _valueCell(Key key, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
    child: Text(text, key: key, textAlign: TextAlign.end),
  );

  /// The amount of [nutrient] in [source] with its unit, or "not informed".
  String _amountText(
    AppLocalizations l10n,
    Nutrients? source,
    Nutrient nutrient,
  ) {
    final value = source?.amountOf(nutrient);
    if (value == null) return l10n.nutritionTableNotInformed;
    return '${_formatNumber(value)} ${_unitLabel(l10n, nutrient.unit)}';
  }

  /// The %VD of [nutrient] from the per-serving amount, or a dash when the
  /// region defines no reference (trans fat) or the amount is absent.
  String _percentText(VdReferenceSet references, Nutrient nutrient) {
    final percent = references.percentOf(
      perServing?.amountOf(nutrient),
      nutrient,
    );
    if (percent == null) return _noReference;
    return '${percent.round()}%';
  }

  String? _servingDescriptor(AppLocalizations l10n) {
    final pieces = <String>[];
    final measure = householdMeasure?.trim();
    if (measure != null && measure.isNotEmpty) pieces.add(measure);
    final size = servingSizeMetric;
    if (size != null && size > 0) pieces.add(_formatServingSize(l10n, size));
    if (pieces.isEmpty) return null;
    if (pieces.length == 2) return '${pieces[0]} (${pieces[1]})';
    return pieces.single;
  }

  String _formatServingSize(AppLocalizations l10n, double metric) {
    if (isLiquid) {
      final unit = unitSystem.volumeUnit;
      final value = VolumeConverter.fromMilliliters(metric, unit);
      final label = unit == VolumeUnit.milliliter
          ? l10n.servingUnitMilliliter
          : l10n.unitFluidOunce;
      return '${_formatNumber(value)} $label';
    }
    final unit = unitSystem.massUnit;
    final value = MassConverter.fromGrams(metric, unit);
    final label = unit == MassUnit.gram ? l10n.unitGram : l10n.unitOunce;
    return '${_formatNumber(value)} $label';
  }

  static String _formatNumber(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);

  String _regionName(AppLocalizations l10n) => switch (vdRegion) {
    VdRegion.brazil => l10n.vdRegionBrazil,
    VdRegion.unitedStates => l10n.vdRegionUnitedStates,
    VdRegion.europeanUnion => l10n.vdRegionEuropeanUnion,
  };

  static String _unitLabel(AppLocalizations l10n, NutrientUnit unit) =>
      switch (unit) {
        NutrientUnit.kilocalorie => l10n.unitKilocalorie,
        NutrientUnit.gram => l10n.unitGram,
        NutrientUnit.milligram => l10n.unitMilligram,
      };

  static String _nutrientLabel(AppLocalizations l10n, Nutrient nutrient) =>
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
}
