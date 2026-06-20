import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The daily-target editor (S-16, FR-022).  Lets the user set or clear their
/// four mandatory macronutrient goals (energy, protein, carbs, total fat) plus
/// optional sodium and dietary fibre.
class DailyTargetScreen extends ConsumerStatefulWidget {
  const DailyTargetScreen({super.key});

  @override
  ConsumerState<DailyTargetScreen> createState() => _DailyTargetScreenState();
}

/// The editable nutrient fields in display order.
const List<Nutrient> _targetNutrients = [
  Nutrient.energy,
  Nutrient.protein,
  Nutrient.carbohydrates,
  Nutrient.totalFat,
  Nutrient.sodium,
  Nutrient.dietaryFiber,
];

class _DailyTargetScreenState extends ConsumerState<DailyTargetScreen> {
  final Map<Nutrient, TextEditingController> _controllers = {};
  String? _error;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    for (final nutrient in _targetNutrients) {
      _controllers[nutrient] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Nutrients? _readTarget() {
    for (final text in _controllers.values.map((c) => c.text)) {
      if (!_parse(text).valid) return null;
    }
    final target = Nutrients(
      energyKcal: _parse(_controllers[Nutrient.energy]!.text).value,
      protein: _parse(_controllers[Nutrient.protein]!.text).value,
      carbohydrates: _parse(_controllers[Nutrient.carbohydrates]!.text).value,
      totalFat: _parse(_controllers[Nutrient.totalFat]!.text).value,
      sodiumMilligrams: _parse(_controllers[Nutrient.sodium]!.text).value,
      dietaryFiber: _parse(_controllers[Nutrient.dietaryFiber]!.text).value,
    );
    if (target == Nutrients.empty) return null;
    return target;
  }

  Future<void> _save() async {
    final target = _readTarget();
    if (target == null) {
      setState(
        () => _error = AppLocalizations.of(context).foodErrorInvalidValue,
      );
      return;
    }
    await ref.read(settingsControllerProvider.notifier).setDailyTarget(target);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _clear() async {
    await ref.read(settingsControllerProvider.notifier).setDailyTarget(null);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);

    if (!_initialized) {
      final data = settings.asData;
      if (data != null) {
        _initialized = true;
        final dailyTarget = data.value.dailyTarget;
        if (dailyTarget != null) {
          for (final nutrient in _targetNutrients) {
            final value = dailyTarget.amountOf(nutrient);
            _controllers[nutrient]?.text = _format(value);
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsDailyTarget),
        actions: [TextButton(onPressed: _save, child: Text(l10n.actionSave))],
      ),
      body: switch (settings) {
        AsyncData() => _buildForm(l10n),
        AsyncError() => Center(child: Text(l10n.settingsLoadError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return ListView(
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
        for (final nutrient in _targetNutrients)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              key: Key('field-${nutrient.name}'),
              controller: _controllers[nutrient],
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: _nutrientLabel(l10n, nutrient),
                suffixText: _unitLabel(l10n, nutrient.unit),
              ),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('clear-target'),
          onPressed: _clear,
          icon: const Icon(Icons.delete_outline),
          label: Text(l10n.settingsClearTarget),
        ),
      ],
    );
  }

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
}
