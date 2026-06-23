import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/foods/data/off_providers.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// First-run onboarding (S-18).
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates the onboarding screen.
  const OnboardingScreen({this.onFinished, super.key});

  /// Test hook or host callback invoked after completion.
  final VoidCallback? onFinished;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

const List<Nutrient> _targetNutrients = [
  Nutrient.energy,
  Nutrient.protein,
  Nutrient.carbohydrates,
  Nutrient.totalFat,
];

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final Map<Nutrient, TextEditingController> _targetControllers = {};
  final TextEditingController _offUserIdController = TextEditingController();
  final TextEditingController _offPasswordController = TextEditingController();

  UnitSystem _unitSystem = UnitSystem.metric;
  String? _error;
  bool _initialized = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    for (final nutrient in _targetNutrients) {
      _targetControllers[nutrient] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _targetControllers.values) {
      controller.dispose();
    }
    _offUserIdController.dispose();
    _offPasswordController.dispose();
    _submitting = false;
    super.dispose();
  }

  void _onSettingsLoaded(AppSettings settings) {
    if (_initialized || !mounted) return;
    _initialized = true;
    setState(() {
      _unitSystem = settings.unitSystem;
      final target = settings.dailyTarget;
      if (target != null) {
        for (final nutrient in _targetNutrients) {
          _targetControllers[nutrient]?.text = _format(
            target.amountOf(nutrient),
          );
        }
      }
    });
  }

  Future<void> _skip() async {
    await ref.read(settingsControllerProvider.notifier).skipOnboarding();
    if (!mounted) return;
    _finish();
  }

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context);
    final targetResult = _readTarget();
    if (!targetResult.valid) {
      setState(() => _error = l10n.foodErrorInvalidValue);
      return;
    }

    final userId = _offUserIdController.text.trim();
    final password = _offPasswordController.text;
    if ((userId.isEmpty && password.isNotEmpty) ||
        (userId.isNotEmpty && password.isEmpty)) {
      setState(() => _error = l10n.onboardingOffCredentialsRequired);
      return;
    }

    setState(() {
      _error = null;
      _submitting = true;
    });
    try {
      if (userId.isNotEmpty) {
        final signedIn = await ref
            .read(offRepositoryProvider)
            .login(userId, password);
        if (!mounted) return;
        if (!signedIn) {
          setState(() {
            _error = l10n.onboardingOffSignInFailed;
            _submitting = false;
          });
          return;
        }
      }

      await ref
          .read(settingsControllerProvider.notifier)
          .completeOnboarding(
            unitSystem: _unitSystem,
            dailyTarget: targetResult.target,
          );
      if (!mounted) return;
    } on Object {
      if (!mounted) return;
      setState(() {
        _error = l10n.onboardingSaveError;
        _submitting = false;
      });
      return;
    }
    _finish();
  }

  void _finish() {
    final onFinished = widget.onFinished;
    if (onFinished != null) {
      onFinished();
      return;
    }
    GoRouter.maybeOf(context)?.go('/diary');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);

    final data = settings.asData;
    if (!_initialized && data != null) _onSettingsLoaded(data.value);

    return Scaffold(
      body: switch (settings) {
        AsyncData() => _buildContent(l10n),
        AsyncError() => Center(child: Text(l10n.settingsLoadError)),
        _ => const SizedBox.shrink(),
      },
      bottomNavigationBar: settings is AsyncData ? _buildActions(l10n) : null,
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.onboardingTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.onboardingTagline,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(l10n.settingsUnitSystem),
            const SizedBox(height: 8),
            SegmentedButton<UnitSystem>(
              segments: [
                ButtonSegment(
                  value: UnitSystem.metric,
                  label: Text(l10n.unitSystemMetric),
                ),
                ButtonSegment(
                  value: UnitSystem.imperial,
                  label: Text(l10n.unitSystemImperial),
                ),
              ],
              selected: {_unitSystem},
              onSelectionChanged: (selection) {
                setState(() => _unitSystem = selection.single);
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.settingsDailyTarget,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final nutrient in _targetNutrients)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  key: Key('field-${nutrient.name}'),
                  controller: _targetControllers[nutrient],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: _nutrientLabel(l10n, nutrient),
                    suffixText: _unitLabel(l10n, nutrient.unit),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingOffTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('field-off-user-id'),
              controller: _offUserIdController,
              decoration: InputDecoration(labelText: l10n.onboardingOffUserId),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('field-off-password'),
              controller: _offPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.onboardingOffPassword,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(AppLocalizations l10n) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: _submitting ? null : _skip,
              child: Text(l10n.actionSkip),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _submitting ? null : _start,
              child: Text(l10n.actionStart),
            ),
          ],
        ),
      ),
    );
  }

  ({bool valid, Nutrients? target}) _readTarget() {
    final values = <Nutrient, double?>{};
    var hasAnyValue = false;
    for (final nutrient in _targetNutrients) {
      final parsed = _parse(_targetControllers[nutrient]!.text);
      if (!parsed.valid) return (valid: false, target: null);
      values[nutrient] = parsed.value;
      hasAnyValue = hasAnyValue || parsed.value != null;
    }
    if (!hasAnyValue) return (valid: true, target: null);
    for (final nutrient in _targetNutrients) {
      if (values[nutrient] == null) {
        setState(
          () => _error = AppLocalizations.of(context).onboardingTargetPartial,
        );
        return (valid: false, target: null);
      }
    }
    return (
      valid: true,
      target: Nutrients(
        energyKcal: values[Nutrient.energy],
        protein: values[Nutrient.protein],
        carbohydrates: values[Nutrient.carbohydrates],
        totalFat: values[Nutrient.totalFat],
      ),
    );
  }

  static ({bool valid, double? value}) _parse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return (valid: true, value: null);
    final parsed = double.tryParse(trimmed.replaceAll(',', '.'));
    if (parsed == null || !parsed.isFinite || parsed < 0) {
      return (valid: false, value: null);
    }
    return (valid: true, value: parsed);
  }

  static String _format(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  static String _nutrientLabel(AppLocalizations l10n, Nutrient nutrient) {
    return switch (nutrient) {
      Nutrient.energy => l10n.nutrientEnergy,
      Nutrient.protein => l10n.nutrientProtein,
      Nutrient.carbohydrates => l10n.nutrientCarbohydrates,
      Nutrient.totalFat => l10n.nutrientTotalFat,
      Nutrient.totalSugars => l10n.nutrientTotalSugars,
      Nutrient.addedSugars => l10n.nutrientAddedSugars,
      Nutrient.saturatedFat => l10n.nutrientSaturatedFat,
      Nutrient.transFat => l10n.nutrientTransFat,
      Nutrient.dietaryFiber => l10n.nutrientDietaryFiber,
      Nutrient.sodium => l10n.nutrientSodium,
    };
  }

  static String _unitLabel(AppLocalizations l10n, NutrientUnit unit) {
    return switch (unit) {
      NutrientUnit.kilocalorie => l10n.unitKilocalorie,
      NutrientUnit.gram => l10n.unitGram,
      NutrientUnit.milligram => l10n.unitMilligram,
    };
  }
}
