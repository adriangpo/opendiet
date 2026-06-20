import 'package:opendiet/core/database/database_providers.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/features/diary/data/drift_diary_repository.dart';
import 'package:opendiet/features/diary/data/drift_meal_slot_repository.dart';
import 'package:opendiet/features/diary/domain/default_meal_slots.dart';
import 'package:opendiet/features/diary/domain/diary_repository.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/diary/domain/meal_slot_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_providers.g.dart';

/// The meal-slot repository, backed by the on-device database.
@Riverpod(keepAlive: true)
MealSlotRepository mealSlotRepository(Ref ref) =>
    DriftMealSlotRepository(ref.watch(appDatabaseProvider));

/// The diary repository, backed by the on-device database.
@Riverpod(keepAlive: true)
DiaryRepository diaryRepository(Ref ref) =>
    DriftDiaryRepository(ref.watch(appDatabaseProvider));

/// All meal slots in position order, seeding default slots on first access.
@Riverpod(keepAlive: true)
Future<List<MealSlot>> mealSlots(Ref ref) async {
  final repository = ref.watch(mealSlotRepositoryProvider);
  final slots = await repository.allMealSlots();
  if (slots.isNotEmpty) return slots;

  final idGenerator = ref.read(idGeneratorProvider);
  final defaults = DefaultMealSlots.build(
    localizedName: _defaultName,
    idGenerator: idGenerator,
  );
  for (final slot in defaults) {
    await repository.saveMealSlot(slot);
  }
  return defaults;
}

String _defaultName(DefaultMealSlotKind kind) => switch (kind) {
  DefaultMealSlotKind.breakfast => 'Breakfast',
  DefaultMealSlotKind.lunch => 'Lunch',
  DefaultMealSlotKind.dinner => 'Dinner',
  DefaultMealSlotKind.snacks => 'Snacks',
};
