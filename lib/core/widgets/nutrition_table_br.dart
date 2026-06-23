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
///
/// Nutrients are grouped into five sections: Macronutrients, Fats, Sugars,
/// Minerals, and Vitamins.
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

  /// Micronutrient keys indented under their parent section.
  static const Set<String> _indentedMicroKeys = {
    Nutrients.cholesterolKey,
    ...Nutrients.fatSubTypeKeys,
    ...Nutrients.sugarSubTypeKeys,
  };

  static const String _noReference = '-';

  // ---------------------------------------------------------------------------
  // Section definitions
  // ---------------------------------------------------------------------------

  /// Macronutrients (Nutrient enum) in the Macronutrients section.
  static const List<Nutrient> _macroNutrients = [
    Nutrient.energy,
    Nutrient.carbohydrates,
    Nutrient.protein,
    Nutrient.totalFat,
    Nutrient.saturatedFat,
    Nutrient.transFat,
    Nutrient.dietaryFiber,
    Nutrient.sodium,
  ];

  /// Nutrient enum values in the Sugars section.
  static const List<Nutrient> _sugarNutrients = [
    Nutrient.totalSugars,
    Nutrient.addedSugars,
  ];

  /// Fat sub-type micronutrient keys.
  static const List<String> _fatSubTypeKeys = [
    Nutrients.monounsaturatedKey,
    Nutrients.polyunsaturatedKey,
    Nutrients.omega3Key,
    Nutrients.omega6Key,
    Nutrients.cholesterolKey,
  ];

  /// Sugar sub-type micronutrient keys.
  static const List<String> _sugarSubTypeKeys = [
    Nutrients.starchKey,
    Nutrients.glucoseKey,
    Nutrients.fructoseKey,
    Nutrients.sucroseKey,
    Nutrients.lactoseKey,
    Nutrients.maltoseKey,
    Nutrients.polyolsKey,
  ];

  /// Mineral micronutrient keys.
  static const List<String> _mineralKeys = [
    Nutrients.calciumKey,
    Nutrients.ironKey,
    Nutrients.potassiumKey,
    Nutrients.magnesiumKey,
    Nutrients.zincKey,
  ];

  /// Vitamin micronutrient keys.
  static const List<String> _vitaminKeys = [
    Nutrients.vitaminAKey,
    Nutrients.vitaminCKey,
    Nutrients.vitaminDKey,
    Nutrients.vitaminB12Key,
  ];

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final references = VdReference.forRegion(vdRegion);
    final servingDescriptor = _servingDescriptor(l10n);
    final header = _headerRow(l10n, theme, servingDescriptor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.nutritionTableTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        // 1. Macronutrients
        _sectionHeader(l10n.nutritionTableSectionMacros, theme),
        _buildTable(
          header: header,
          rows: [
            for (final nutrient in _macroNutrients)
              _nutrientRow(l10n, theme, references, nutrient),
          ],
        ),
        const SizedBox(height: 6),
        // 2. Fats
        _sectionHeader(l10n.nutritionTableSectionFats, theme),
        _buildTable(
          header: header,
          rows: [
            for (final key in _fatSubTypeKeys)
              _micronutrientRow(l10n, theme, references, key),
          ],
        ),
        const SizedBox(height: 6),
        // 3. Sugars
        _sectionHeader(l10n.nutritionTableSectionSugars, theme),
        _buildTable(
          header: header,
          rows: [
            for (final nutrient in _sugarNutrients)
              _nutrientRow(l10n, theme, references, nutrient),
            for (final key in _sugarSubTypeKeys)
              _micronutrientRow(l10n, theme, references, key),
          ],
        ),
        const SizedBox(height: 6),
        // 4. Minerals
        _sectionHeader(l10n.nutritionTableSectionMinerals, theme),
        _buildTable(
          header: header,
          rows: [
            for (final key in _mineralKeys)
              _micronutrientRow(l10n, theme, references, key),
          ],
        ),
        const SizedBox(height: 6),
        // 5. Vitamins
        _sectionHeader(l10n.nutritionTableSectionVitamins, theme),
        _buildTable(
          header: header,
          rows: [
            for (final key in _vitaminKeys)
              _micronutrientRow(l10n, theme, references, key),
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

  /// A section header label between table sections.
  Widget _sectionHeader(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds a [Table] with [header] as the first row followed by [rows].
  Widget _buildTable({
    required TableRow header,
    required List<TableRow> rows,
  }) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.6),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(0.8),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [header, ...rows],
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

  /// A row for a micronutrient identified by [key].
  TableRow _micronutrientRow(
    AppLocalizations l10n,
    ThemeData theme,
    VdReferenceSet references,
    String key,
  ) {
    final indent = _indentedMicroKeys.contains(key) ? 16.0 : 0.0;
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(indent, 6, 4, 6),
          child: Text(_micronutrientLabel(l10n, key)),
        ),
        _valueCell(
          Key('nutrition-$key-per100'),
          _micronutrientAmountText(l10n, per100, key),
        ),
        _valueCell(
          Key('nutrition-$key-perServing'),
          _micronutrientAmountText(l10n, perServing, key),
        ),
        _valueCell(
          Key('nutrition-$key-vd'),
          _micronutrientPercentText(references, key),
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

  /// The amount of micronutrient [key] in [source] with its unit, or
  /// "not informed".
  String _micronutrientAmountText(
    AppLocalizations l10n,
    Nutrients? source,
    String key,
  ) {
    final value = source?.micronutrient(key);
    if (value == null) return l10n.nutritionTableNotInformed;
    return '${_formatNumber(value)} ${_micronutrientUnitLabel(l10n, key)}';
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

  /// The %VD for a micronutrient [key], or a dash when absent or no reference.
  String _micronutrientPercentText(VdReferenceSet references, String key) {
    final percent = references.micronutrientPercentOf(
      perServing?.micronutrient(key),
      key,
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

  /// The label for a micronutrient identified by [key].
  static String _micronutrientLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        Nutrients.calciumKey => l10n.nutrientCalcium,
        Nutrients.ironKey => l10n.nutrientIron,
        Nutrients.potassiumKey => l10n.nutrientPotassium,
        Nutrients.magnesiumKey => l10n.nutrientMagnesium,
        Nutrients.zincKey => l10n.nutrientZinc,
        Nutrients.vitaminAKey => l10n.nutrientVitaminA,
        Nutrients.vitaminCKey => l10n.nutrientVitaminC,
        Nutrients.vitaminDKey => l10n.nutrientVitaminD,
        Nutrients.vitaminB12Key => l10n.nutrientVitaminB12,
        Nutrients.starchKey => l10n.nutrientStarch,
        Nutrients.glucoseKey => l10n.nutrientGlucose,
        Nutrients.fructoseKey => l10n.nutrientFructose,
        Nutrients.sucroseKey => l10n.nutrientSucrose,
        Nutrients.lactoseKey => l10n.nutrientLactose,
        Nutrients.maltoseKey => l10n.nutrientMaltose,
        Nutrients.polyolsKey => l10n.nutrientPolyols,
        Nutrients.monounsaturatedKey => l10n.nutrientMonounsaturated,
        Nutrients.polyunsaturatedKey => l10n.nutrientPolyunsaturated,
        Nutrients.omega3Key => l10n.nutrientOmega3,
        Nutrients.omega6Key => l10n.nutrientOmega6,
        Nutrients.cholesterolKey => l10n.nutrientCholesterol,
        _ => key,
      };

  /// The unit label for a micronutrient key based on its suffix.
  static String _micronutrientUnitLabel(AppLocalizations l10n, String key) {
    if (key.endsWith('_g')) return l10n.unitGram;
    if (key.endsWith('_mg')) return l10n.unitMilligram;
    if (key.endsWith('_mcg')) return l10n.unitMicrogram;
    return '';
  }
}
