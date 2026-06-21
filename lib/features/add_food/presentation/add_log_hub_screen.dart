import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/widgets/food_list_tile.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_day_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_nutrition.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// The tab segments within the add/log hub (FR-018).
enum AddLogSegment { recent, favorites, foods }

/// The Add / Log hub (S-02): search, recents, favorites, local foods.
///
/// [mealSlotId] preselects the target meal slot.
class AddLogHubScreen extends ConsumerStatefulWidget {
  /// Creates the hub for the given [mealSlotId].
  const AddLogHubScreen({required this.mealSlotId, super.key});

  /// The meal slot new entries are added to.
  final String mealSlotId;

  @override
  ConsumerState<AddLogHubScreen> createState() => _AddLogHubScreenState();
}

class _AddLogHubScreenState extends ConsumerState<AddLogHubScreen> {
  AddLogSegment _segment = AddLogSegment.recent;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final foodsAsync = ref.watch(foodListProvider);
    final recentsAsync = ref.watch(recentFoodsProvider);
    final favoritesAsync = ref.watch(favoriteFoodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addLogHubTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _SearchBar(controller: _searchController, l10n: l10n),
          _SegmentSelector(
            segment: _segment,
            onChanged: (s) => setState(() => _segment = s),
            l10n: l10n,
          ),
          Expanded(
            child: _buildFoodList(
              recentsAsync: recentsAsync,
              favoritesAsync: favoritesAsync,
              allFoodsAsync: foodsAsync,
              l10n: l10n,
            ),
          ),
          _BottomActions(l10n: l10n, mealSlotId: widget.mealSlotId),
        ],
      ),
    );
  }

  Widget _buildFoodList({
    required AsyncValue<List<Food>> recentsAsync,
    required AsyncValue<List<Food>> favoritesAsync,
    required AsyncValue<List<Food>> allFoodsAsync,
    required AppLocalizations l10n,
  }) {
    final AsyncValue<List<Food>> targetAsync;
    final String emptyMessage;

    switch (_segment) {
      case AddLogSegment.recent:
        targetAsync = recentsAsync;
        emptyMessage = l10n.addLogRecentsEmpty;
      case AddLogSegment.favorites:
        targetAsync = favoritesAsync;
        emptyMessage = l10n.addLogFavoritesEmpty;
      case AddLogSegment.foods:
        targetAsync = allFoodsAsync;
        emptyMessage = l10n.foodsEmptyMessage;
    }

    return targetAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Center(child: Text(l10n.foodsLoadError)),
      data: (foods) {
        if (foods.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) => _QuickLogTile(
            food: foods[index],
            mealSlotId: widget.mealSlotId,
            l10n: l10n,
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.l10n});

  final TextEditingController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: l10n.addLogSearchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.qr_code_scanner),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _SegmentSelector extends StatelessWidget {
  const _SegmentSelector({
    required this.segment,
    required this.onChanged,
    required this.l10n,
  });

  final AddLogSegment segment;
  final ValueChanged<AddLogSegment> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _Chip(
            label: l10n.addLogSegmentRecent,
            selected: segment == AddLogSegment.recent,
            onTap: () => onChanged(AddLogSegment.recent),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: l10n.addLogSegmentFavorites,
            selected: segment == AddLogSegment.favorites,
            onTap: () => onChanged(AddLogSegment.favorites),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: l10n.addLogSegmentFoods,
            selected: segment == AddLogSegment.foods,
            onTap: () => onChanged(AddLogSegment.foods),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// A food row with a quick-log + button that logs 1 serving directly.
class _QuickLogTile extends ConsumerWidget {
  const _QuickLogTile({
    required this.food,
    required this.mealSlotId,
    required this.l10n,
  });

  final Food food;
  final String mealSlotId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FoodListTile(
      food: food,
      actionLabel: l10n.addLogQuickLogTooltip,
      onAction: () => _quickLog(ref, context),
    );
  }

  Future<void> _quickLog(WidgetRef ref, BuildContext context) async {
    final repo = ref.read(diaryRepositoryProvider);
    final idGenerator = ref.read(idGeneratorProvider);
    final clock = ref.read(clockProvider);
    final now = clock.now();
    final day = ref.read(diaryDayProvider);

    final quantity = _defaultQuickLogQuantity(food);
    final servingNutrition = FoodNutrition.forQuantity(
      food,
      quantity,
    );

    final entry = DiaryEntry(
      id: idGenerator.newId(),
      day: day,
      mealSlotId: mealSlotId,
      referenceKind: DiaryReferenceKind.food,
      referenceId: food.id,
      label: food.name,
      quantity: quantity,
      nutrients: Nutrients(
        energyKcal: servingNutrition.energyKcal,
        carbohydrates: servingNutrition.carbohydrates,
        totalSugars: servingNutrition.totalSugars,
        addedSugars: servingNutrition.addedSugars,
        protein: servingNutrition.protein,
        totalFat: servingNutrition.totalFat,
        saturatedFat: servingNutrition.saturatedFat,
        transFat: servingNutrition.transFat,
        dietaryFiber: servingNutrition.dietaryFiber,
        sodiumMilligrams: servingNutrition.sodiumMilligrams,
        micronutrients: servingNutrition.micronutrients,
      ),
      loggedAt: now,
    );

    await repo.saveEntry(entry);
    await ref.read(foodRepositoryProvider).markLastLoggedAt(food.id, now);

    if (!context.mounted) return;
    context.pop();
  }

  Quantity _defaultQuickLogQuantity(Food food) => switch (food.basis) {
    NutrientBasis.per100g when _hasServingSize(food) => Quantity.servings(1),
    NutrientBasis.per100ml when _hasServingSize(food) => Quantity.servings(1),
    NutrientBasis.per100g => Quantity.grams(100),
    NutrientBasis.per100ml => Quantity.milliliters(100),
    NutrientBasis.perServing => Quantity.servings(1),
  };

  bool _hasServingSize(Food food) {
    final size = food.servingSizeMetric;
    return size != null && size > 0;
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.l10n, required this.mealSlotId});

  final AppLocalizations l10n;
  final String mealSlotId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => context.push('/foods/new'),
              icon: const Icon(Icons.add),
              label: Text(l10n.addLogCreateCustom),
            ),
          ],
        ),
      ),
    );
  }
}
