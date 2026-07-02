import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/quick_add.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// A quick-add form for logging an ad-hoc food straight into a meal slot
/// (FR-031). Accessed from `/log?slot={id}&date={isoDate}`.
///
/// When [existingEntry] is provided, the form pre-fills its fields and saves as
/// an update (same entry id) instead of creating a new entry.
class QuickAddScreen extends ConsumerStatefulWidget {
  /// Creates a quick-add screen for [slotId] on [day].
  const QuickAddScreen({
    required this.slotId,
    required this.day,
    this.existingEntry,
    super.key,
  });

  /// The meal slot to add to.
  final String slotId;

  /// The calendar day for the entry.
  final DateTime day;

  /// When set, pre-fills the form and updates this entry on save.
  final DiaryEntry? existingEntry;

  @override
  ConsumerState<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends ConsumerState<QuickAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _energyController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final existing = widget.existingEntry;
    if (existing != null) {
      _nameController.text = existing.label;
      final energy = existing.nutrients.energyKcal;
      if (energy != null) {
        _energyController.text = energy.roundToDouble() == energy
            ? energy.toInt().toString()
            : energy.toString();
      }
      _setIfPresent(_proteinController, existing.nutrients.protein);
      _setIfPresent(_carbsController, existing.nutrients.carbohydrates);
      _setIfPresent(_fatController, existing.nutrients.totalFat);
    }
  }

  void _setIfPresent(TextEditingController ctrl, double? value) {
    if (value != null) {
      ctrl.text = value.roundToDouble() == value
          ? value.toInt().toString()
          : value.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _energyController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = ref.read(diaryRepositoryProvider);
    final idGenerator = ref.read(idGeneratorProvider);
    final clock = ref.read(clockProvider);
    final now = clock.now();
    final existing = widget.existingEntry;

    final additionalNutrients = Nutrients(
      protein: _doubleOrNull(_proteinController.text),
      carbohydrates: _doubleOrNull(_carbsController.text),
      totalFat: _doubleOrNull(_fatController.text),
    );

    final entry = QuickAdd.entry(
      id: existing?.id ?? idGenerator.newId(),
      mealSlotId: widget.slotId,
      day: widget.day,
      loggedAt: existing?.loggedAt ?? now,
      name: _nameController.text,
      energyKcal: double.parse(_energyController.text),
      additionalNutrients: additionalNutrients,
    );

    await repository.saveEntry(entry);
    ref.read(diaryMutationProvider.notifier).touch();

    if (mounted) _closeAfterSave();
  }

  void _closeAfterSave() {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      if (router.canPop()) {
        context.pop();
      } else {
        context.go('/diary');
      }
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slotsAsync = ref.watch(mealSlotsProvider);
    final slotName = slotsAsync.maybeWhen(
      data: (slots) {
        final slot = slots.where((s) => s.id == widget.slotId).firstOrNull;
        return slot?.name ?? '';
      },
      orElse: () => '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logAddToSlot(slotName)),
        leading: IconButton(
          icon: const Icon(Boxicons.bx_x),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('field-name'),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.foodFieldName,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.foodErrorNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('field-energy'),
              controller: _energyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${l10n.nutrientEnergy} (${l10n.unitKilocalorie})',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.foodErrorInvalidValue;
                }
                final v = double.tryParse(value);
                if (v == null || !v.isFinite || v < 0) {
                  return l10n.foodErrorInvalidValue;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.logOptionalNutrients,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('field-protein'),
              controller: _proteinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${l10n.nutrientProtein} (${l10n.unitGram})',
              ),
              validator: (value) => _validateOptionalNumber(value, l10n),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('field-carbohydrates'),
              controller: _carbsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${l10n.nutrientCarbohydrates} (${l10n.unitGram})',
              ),
              validator: (value) => _validateOptionalNumber(value, l10n),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('field-total-fat'),
              controller: _fatController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${l10n.nutrientTotalFat} (${l10n.unitGram})',
              ),
              validator: (value) => _validateOptionalNumber(value, l10n),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: Text(l10n.actionSave),
            ),
          ],
        ),
      ),
    );
  }

  double? _doubleOrNull(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    final v = double.tryParse(trimmed);
    if (v == null || !v.isFinite || v < 0) return null;
    return v;
  }

  String? _validateOptionalNumber(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    final v = double.tryParse(trimmed);
    if (v == null || !v.isFinite || v < 0) {
      return l10n.foodErrorInvalidValue;
    }
    return null;
  }
}
