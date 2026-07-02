import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/widgets/quantity_field.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_nutrition.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Quantity entry for saved foods (S-04, FR-003).
///
/// When [existingEntry] is provided, the form pre-fills the quantity and meal
/// slot from that entry and saves as an update (same entry id) instead of
/// creating a new entry.
class FoodQuantityEntryScreen extends ConsumerStatefulWidget {
  /// Creates a saved-food quantity entry screen.
  const FoodQuantityEntryScreen({
    required this.foodId,
    required this.day,
    this.mealSlotId,
    this.existingEntry,
    super.key,
  });

  /// The saved food id to log.
  final String foodId;

  /// The diary day receiving the entry.
  final DateTime day;

  /// Optional preselected meal slot.
  final String? mealSlotId;

  /// When set, pre-fills the form and updates this entry on save.
  final DiaryEntry? existingEntry;

  @override
  ConsumerState<FoodQuantityEntryScreen> createState() =>
      _FoodQuantityEntryScreenState();
}

class _FoodQuantityEntryScreenState
    extends ConsumerState<FoodQuantityEntryScreen> {
  Quantity? _quantity;
  String? _mealSlotId;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingEntry;
    if (existing != null) {
      _quantity = existing.quantity;
      _mealSlotId = existing.mealSlotId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final foods = ref.watch(foodListProvider);
    final slots = ref.watch(mealSlotsProvider);
    final settings =
        ref.watch(settingsControllerProvider).asData?.value ??
        AppSettings.defaults;

    return foods.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.foodDetailLogFood)),
        body: const SizedBox.shrink(),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.foodDetailLogFood)),
        body: Center(child: Text(l10n.foodsLoadError)),
      ),
      data: (items) {
        final food = items
            .where((item) => item.id == widget.foodId)
            .firstOrNull;
        if (food == null) return _NotFoundScreen(l10n: l10n);
        return Scaffold(
          appBar: AppBar(
            title: Text(food.name),
            actions: [
              IconButton(
                key: const Key('food-quantity-favorite-button'),
                tooltip: food.isFavorite
                    ? l10n.foodDetailFavoriteRemove
                    : l10n.foodDetailFavoriteAdd,
                icon: Icon(
                  food.isFavorite ? Boxicons.bxs_heart : Boxicons.bx_heart,
                ),
                onPressed: () => unawaited(
                  ref.read(foodRepositoryProvider).toggleFavorite(food.id),
                ),
              ),
            ],
          ),
          body: slots.when(
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => Center(child: Text(l10n.diaryLoadError)),
            data: (mealSlots) => _QuantityEntryForm(
              food: food,
              slots: mealSlots,
              settings: settings,
              selectedMealSlotId: _selectedMealSlotId(mealSlots),
              quantity: _quantity,
              onMealSlotChanged: (id) => setState(() => _mealSlotId = id),
              onQuantityChanged: (quantity) =>
                  setState(() => _quantity = quantity),
              onSave: _canSave(mealSlots)
                  ? () => _save(food, _selectedMealSlotId(mealSlots)!)
                  : null,
            ),
          ),
        );
      },
    );
  }

  String? _selectedMealSlotId(List<MealSlot> slots) {
    if (slots.isEmpty) return null;
    final selected = _mealSlotId ?? widget.mealSlotId;
    if (selected != null && slots.any((slot) => slot.id == selected)) {
      return selected;
    }
    return slots.first.id;
  }

  bool _canSave(List<MealSlot> slots) =>
      _quantity != null && _selectedMealSlotId(slots) != null;

  Future<void> _save(Food food, String mealSlotId) async {
    final quantity = _quantity;
    if (quantity == null) {
      throw StateError('Quantity must not be null when saving');
    }

    final now = ref.read(clockProvider).now();
    final nutrients = FoodNutrition.forQuantity(food, quantity);
    final existing = widget.existingEntry;
    final entry = DiaryEntry(
      id: existing?.id ?? ref.read(idGeneratorProvider).newId(),
      day: widget.day,
      mealSlotId: mealSlotId,
      referenceKind: DiaryReferenceKind.food,
      referenceId: food.id,
      label: food.name,
      quantity: quantity,
      nutrients: nutrients,
      loggedAt: existing?.loggedAt ?? now,
    );

    await ref.read(diaryRepositoryProvider).saveEntry(entry);
    if (existing == null) {
      await ref.read(foodRepositoryProvider).markLastLoggedAt(food.id, now);
    }
    ref.read(diaryMutationProvider.notifier).touch();

    if (!mounted) return;
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
}

class _QuantityEntryForm extends StatelessWidget {
  const _QuantityEntryForm({
    required this.food,
    required this.slots,
    required this.settings,
    required this.selectedMealSlotId,
    required this.quantity,
    required this.onMealSlotChanged,
    required this.onQuantityChanged,
    required this.onSave,
  });

  final Food food;
  final List<MealSlot> slots;
  final AppSettings settings;
  final String? selectedMealSlotId;
  final Quantity? quantity;
  final ValueChanged<String> onMealSlotChanged;
  final ValueChanged<Quantity?> onQuantityChanged;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preview = _previewNutrients();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        QuantityField(
          unitSystem: settings.unitSystem,
          hasServingSize: _hasServingSize(food),
          initialValue: _defaultQuantity(food),
          onChanged: onQuantityChanged,
        ),
        const SizedBox(height: 16),
        _MealSlotSelector(
          slots: slots,
          selectedMealSlotId: selectedMealSlotId,
          onChanged: onMealSlotChanged,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.foodQuantityPreviewTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(_previewText(l10n, preview)),
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('food-quantity-save-button'),
          onPressed: onSave,
          child: Text(l10n.foodQuantityAddToDiary),
        ),
      ],
    );
  }

  Nutrients? _previewNutrients() {
    final current = quantity;
    if (current == null) return null;
    if (!_canCompute(food, current)) return null;
    return FoodNutrition.forQuantity(food, current);
  }

  String _previewText(AppLocalizations l10n, Nutrients? nutrients) {
    final energy = nutrients?.energyKcal;
    if (energy == null) return l10n.nutritionTableNotInformed;
    return '${_formatNumber(energy)} ${l10n.unitKilocalorie}';
  }

  bool _hasServingSize(Food food) {
    final size = food.servingSizeMetric;
    return size != null && size > 0;
  }

  Quantity _defaultQuantity(Food food) => switch (food.basis) {
    NutrientBasis.per100g when _hasServingSize(food) => Quantity.servings(1),
    NutrientBasis.per100ml when _hasServingSize(food) => Quantity.servings(1),
    NutrientBasis.perServing when _hasServingSize(food) => Quantity.servings(1),
    NutrientBasis.per100g => Quantity.grams(100),
    NutrientBasis.per100ml => Quantity.milliliters(100),
    NutrientBasis.perServing => Quantity.grams(100),
  };

  bool _canCompute(Food food, Quantity quantity) => switch (quantity.measure) {
    QuantityMeasure.servings =>
      food.basis == NutrientBasis.perServing || _hasServingSize(food),
    QuantityMeasure.grams || QuantityMeasure.milliliters =>
      food.basis != NutrientBasis.perServing || _hasServingSize(food),
  };

  String _formatNumber(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}

class _MealSlotSelector extends StatelessWidget {
  const _MealSlotSelector({
    required this.slots,
    required this.selectedMealSlotId,
    required this.onChanged,
  });

  final List<MealSlot> slots;
  final String? selectedMealSlotId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (slots.isEmpty || selectedMealSlotId == null) {
      return Text(l10n.foodQuantityNoMealSlots);
    }
    if (slots.length == 1) return Text(slots.single.name);
    return DropdownButton<String>(
      value: selectedMealSlotId,
      isExpanded: true,
      items: [
        for (final slot in slots)
          DropdownMenuItem(value: slot.id, child: Text(slot.name)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(l10n.foodDetailLogFood)),
    body: Center(child: Text(l10n.foodDetailNotFound)),
  );
}
