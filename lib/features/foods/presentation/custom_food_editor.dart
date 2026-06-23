import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/energy_estimator.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/presentation/barcode_scanner_screen.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The custom-food editor (S-05, FR-008/FR-024/FR-028).
///
/// Energy auto-fills from the macros while automatic; editing it hands
/// ownership to the user (manual), and the trailing icon toggles that state
/// back to automatic (FR-008 auto-calc). [initialFood] prefills the form for
/// editing or for promoting a quick-added entry (FR-031).
class CustomFoodEditor extends ConsumerStatefulWidget {
  /// Creates the editor, optionally seeded with [initialFood].
  const CustomFoodEditor({this.initialFood, this.onSaved, super.key});

  /// The food to edit, or null to create a new one.
  final Food? initialFood;

  /// Called with the saved food after a successful save.
  final void Function(Food food)? onSaved;

  @override
  ConsumerState<CustomFoodEditor> createState() => _CustomFoodEditorState();
}

/// The macronutrient fields, in ANVISA order (energy is handled separately).
const List<Nutrient> _macroNutrients = [
  Nutrient.carbohydrates,
  Nutrient.totalSugars,
  Nutrient.addedSugars,
  Nutrient.protein,
  Nutrient.totalFat,
  Nutrient.saturatedFat,
  Nutrient.transFat,
  Nutrient.dietaryFiber,
  Nutrient.sodium,
];

/// Micronutrient keys displayed in the optional nutrients section.
const List<String> _micronutrientKeys = [
  Nutrients.cholesterolKey,
  Nutrients.calciumKey,
  Nutrients.ironKey,
  Nutrients.potassiumKey,
  Nutrients.magnesiumKey,
  Nutrients.zincKey,
  Nutrients.vitaminAKey,
  Nutrients.vitaminCKey,
  Nutrients.vitaminDKey,
  Nutrients.vitaminB12Key,
];

/// Sugar sub-type keys displayed under the "Sugars" sub-section header.
const List<String> _sugarSubTypeKeys = [
  Nutrients.starchKey,
  Nutrients.glucoseKey,
  Nutrients.fructoseKey,
  Nutrients.sucroseKey,
  Nutrients.lactoseKey,
  Nutrients.maltoseKey,
  Nutrients.polyolsKey,
];

/// Fat sub-type keys displayed under the "Fats" sub-section header.
const List<String> _fatSubTypeKeys = [
  Nutrients.monounsaturatedKey,
  Nutrients.polyunsaturatedKey,
  Nutrients.omega3Key,
  Nutrients.omega6Key,
];

/// Every key tracked in the micronutrient-controllers map.
const List<String> _allOptionalKeys = [
  ..._micronutrientKeys,
  ..._sugarSubTypeKeys,
  ..._fatSubTypeKeys,
];

class _CustomFoodEditorState extends ConsumerState<CustomFoodEditor> {
  late final TextEditingController _name;
  late final TextEditingController _brand;
  late final TextEditingController _barcode;
  late final TextEditingController _servingSize;
  late final TextEditingController _householdMeasure;
  late final TextEditingController _energy;
  late final Map<Nutrient, TextEditingController> _macros;
  late final Map<String, TextEditingController> _micronutrientControllers;

  bool _optionalExpanded = false;
  late NutrientBasis _basis;
  late ServingUnit _servingUnit;
  late bool _energyIsManual;
  bool _suppressEnergyListener = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final food = widget.initialFood;
    final nutrients = food?.nutrients ?? Nutrients.empty;
    _name = TextEditingController(text: food?.name ?? '');
    _brand = TextEditingController(text: food?.brand ?? '');
    _barcode = TextEditingController(text: food?.barcode ?? '');
    _servingSize = TextEditingController(
      text: _format(food?.servingSizeMetric),
    );
    _householdMeasure = TextEditingController(
      text: food?.householdMeasure ?? '',
    );
    _basis = food?.basis ?? NutrientBasis.perServing;
    _servingUnit = food?.servingUnit ?? ServingUnit.gram;
    _energyIsManual = food?.energyIsManual ?? false;
    _energy = TextEditingController(text: _format(nutrients.energyKcal))
      ..addListener(_onEnergyEdited);
    _macros = {
      for (final nutrient in _macroNutrients)
        nutrient: TextEditingController(
          text: _format(nutrients.amountOf(nutrient)),
        )..addListener(_onMacrosEdited),
    };
    _micronutrientControllers = {
      for (final key in _allOptionalKeys)
        key: TextEditingController(
          text: _format(nutrients.micronutrients[key]),
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _brand,
      _barcode,
      _servingSize,
      _householdMeasure,
      _energy,
      ..._macros.values,
    ]) {
      controller.dispose();
    }
    for (final controller in _micronutrientControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onEnergyEdited() {
    if (_suppressEnergyListener || _energyIsManual) return;
    setState(() => _energyIsManual = true);
  }

  void _onMacrosEdited() {
    if (_energyIsManual) return;
    _writeEnergyField(EnergyEstimator.fromMacros(_readMacros()));
  }

  void _toggleEnergyMode() {
    if (!_energyIsManual) return;
    setState(() => _energyIsManual = false);
    _writeEnergyField(EnergyEstimator.fromMacros(_readMacros()));
  }

  void _writeEnergyField(double? value) {
    _suppressEnergyListener = true;
    _energy.text = _format(value);
    _suppressEnergyListener = false;
  }

  Future<void> _scanBarcode() async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const BarcodeScannerScreen(),
      ),
    );
    if (barcode != null && mounted) {
      _barcode.text = barcode;
    }
  }

  Nutrients _readMacros() => Nutrients(
    carbohydrates: _parse(_macros[Nutrient.carbohydrates]!.text).value,
    totalSugars: _parse(_macros[Nutrient.totalSugars]!.text).value,
    addedSugars: _parse(_macros[Nutrient.addedSugars]!.text).value,
    protein: _parse(_macros[Nutrient.protein]!.text).value,
    totalFat: _parse(_macros[Nutrient.totalFat]!.text).value,
    saturatedFat: _parse(_macros[Nutrient.saturatedFat]!.text).value,
    transFat: _parse(_macros[Nutrient.transFat]!.text).value,
    dietaryFiber: _parse(_macros[Nutrient.dietaryFiber]!.text).value,
    sodiumMilligrams: _parse(_macros[Nutrient.sodium]!.text).value,
  );

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(
        () => _error = AppLocalizations.of(context).foodErrorNameRequired,
      );
      return;
    }
    final everyField = [
      _energy.text,
      ..._macros.values.map((c) => c.text),
      ..._micronutrientControllers.values.map((c) => c.text),
    ];
    if (everyField.any((text) => !_parse(text).valid)) {
      setState(
        () => _error = AppLocalizations.of(context).foodErrorInvalidValue,
      );
      return;
    }

    final macros = _readMacros();
    final energy = _energyIsManual
        ? _parse(_energy.text).value
        : EnergyEstimator.fromMacros(macros);
    final micronutrients = <String, double>{};
    for (final entry in _micronutrientControllers.entries) {
      final parsed = _parse(entry.value.text);
      if (parsed.valid && parsed.value != null) {
        micronutrients[entry.key] = parsed.value!;
      }
    }
    final nutrients = macros.copyWith(
      energyKcal: energy,
      micronutrients: micronutrients,
    );

    final now = ref.read(clockProvider).now();
    final existing = widget.initialFood;
    final food = Food(
      id: existing?.id ?? ref.read(idGeneratorProvider).newId(),
      name: name,
      brand: _trimToNull(_brand.text),
      barcode: _trimToNull(_barcode.text),
      source: existing?.source ?? FoodSource.custom,
      basis: _basis,
      nutrients: nutrients,
      servingSizeMetric: _parse(_servingSize.text).value,
      servingUnit: _servingUnit,
      householdMeasure: _trimToNull(_householdMeasure.text),
      energyIsManual: _energyIsManual,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await ref.read(foodRepositoryProvider).saveFood(food);
    if (!mounted) return;
    widget.onSaved?.call(food);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialFood == null
              ? l10n.foodEditorNewTitle
              : l10n.foodEditorEditTitle,
        ),
        actions: [TextButton(onPressed: _save, child: Text(l10n.actionSave))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          TextField(
            key: const Key('field-name'),
            controller: _name,
            decoration: InputDecoration(
              labelText: '${l10n.foodFieldName} *',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _brand,
            decoration: InputDecoration(labelText: l10n.foodFieldBrand),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('field-barcode'),
            controller: _barcode,
            decoration: InputDecoration(
              labelText: l10n.foodFieldBarcode,
              suffixIcon: IconButton(
                icon: const Icon(Boxicons.bx_qr),
                onPressed: _scanBarcode,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _basisSelector(l10n),
          if (_basis == NutrientBasis.perServing) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _servingSize,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.foodFieldServingSize,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _servingUnitSelector(l10n),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _householdMeasure,
              decoration: InputDecoration(
                labelText: l10n.foodFieldHouseholdMeasure,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _energyField(l10n),
          for (final nutrient in _macroNutrients) ...[
            const SizedBox(height: 12),
            _nutrientField(l10n, nutrient),
          ],
          const SizedBox(height: 12),
          InkWell(
            key: const Key('optional-nutrients-section'),
            onTap: () => setState(() => _optionalExpanded = !_optionalExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.logOptionalNutrients,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    _optionalExpanded
                        ? Boxicons.bx_chevron_up
                        : Boxicons.bx_chevron_down,
                  ),
                ],
              ),
            ),
          ),
          if (_optionalExpanded) ...[
            for (final key in _micronutrientKeys)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _micronutrientField(l10n, key),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.nutritionTableSectionSugars,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            for (final key in _sugarSubTypeKeys)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _micronutrientField(l10n, key),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.nutritionTableSectionFats,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            for (final key in _fatSubTypeKeys)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _micronutrientField(l10n, key),
              ),
          ],
        ],
      ),
    );
  }

  Widget _basisSelector(AppLocalizations l10n) =>
      SegmentedButton<NutrientBasis>(
        segments: [
          ButtonSegment(
            value: NutrientBasis.per100g,
            label: Text(l10n.foodBasisPer100g),
          ),
          ButtonSegment(
            value: NutrientBasis.per100ml,
            label: Text(l10n.foodBasisPer100ml),
          ),
          ButtonSegment(
            value: NutrientBasis.perServing,
            label: Text(l10n.foodBasisPerServing),
          ),
        ],
        selected: {_basis},
        onSelectionChanged: (selection) =>
            setState(() => _basis = selection.single),
      );

  Widget _servingUnitSelector(AppLocalizations l10n) =>
      DropdownButton<ServingUnit>(
        value: _servingUnit,
        onChanged: (unit) {
          if (unit != null) setState(() => _servingUnit = unit);
        },
        items: [
          DropdownMenuItem(
            value: ServingUnit.gram,
            child: Text(l10n.servingUnitGram),
          ),
          DropdownMenuItem(
            value: ServingUnit.milliliter,
            child: Text(l10n.servingUnitMilliliter),
          ),
          DropdownMenuItem(
            value: ServingUnit.piece,
            child: Text(l10n.servingUnitPiece),
          ),
        ],
      );

  Widget _energyField(AppLocalizations l10n) => Row(
    children: [
      Expanded(
        child: TextField(
          key: const Key('field-energy'),
          controller: _energy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '${l10n.nutrientEnergy} *',
            suffixText: l10n.unitKilocalorie,
          ),
        ),
      ),
      IconButton(
        key: const Key('energy-mode-toggle'),
        tooltip: _energyIsManual
            ? l10n.foodEnergyManualLabel
            : l10n.foodEnergyAutoLabel,
        onPressed: _toggleEnergyMode,
        icon: Icon(
          _energyIsManual ? Boxicons.bx_lock : Boxicons.bx_calculator,
        ),
      ),
    ],
  );

  Widget _nutrientField(AppLocalizations l10n, Nutrient nutrient) => TextField(
    key: Key('field-${nutrient.name}'),
    controller: _macros[nutrient],
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: _nutrientLabel(l10n, nutrient),
      suffixText: _unitLabel(l10n, nutrient.unit),
    ),
  );

  Widget _micronutrientField(AppLocalizations l10n, String key) => TextField(
    key: Key('field-$key'),
    controller: _micronutrientControllers[key],
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: _micronutrientLabel(l10n, key),
      suffixText: _unitForKey(l10n, key),
    ),
  );

  static String _format(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  static ({bool valid, double? value}) _parse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return (valid: true, value: null);
    final parsed = double.tryParse(trimmed.replaceAll(',', '.'));
    if (parsed == null || parsed < 0) return (valid: false, value: null);
    return (valid: true, value: parsed);
  }

  static String? _trimToNull(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

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

  static String _unitLabel(AppLocalizations l10n, NutrientUnit unit) =>
      switch (unit) {
        NutrientUnit.kilocalorie => l10n.unitKilocalorie,
        NutrientUnit.gram => l10n.unitGram,
        NutrientUnit.milligram => l10n.unitMilligram,
      };

  static String _micronutrientLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        Nutrients.cholesterolKey => l10n.nutrientCholesterol,
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
        _ => key,
      };

  static String _unitForKey(AppLocalizations l10n, String key) {
    if (key.endsWith('_mg')) return l10n.unitMilligram;
    if (key.endsWith('_mcg')) return l10n.unitMicrogram;
    return l10n.unitGram;
  }
}
