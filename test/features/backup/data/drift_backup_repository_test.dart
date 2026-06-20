import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/backup/data/drift_backup_repository.dart';
import 'package:opendiet/features/backup/domain/backup_document.dart';
import 'package:opendiet/features/diary/data/drift_diary_repository.dart';
import 'package:opendiet/features/diary/data/drift_meal_slot_repository.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/drift_food_repository.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/drift_recipe_repository.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/settings/data/drift_settings_repository.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';

/// A self-contained set of repositories over a single in-memory database.
class _Harness {
  _Harness() : database = AppDatabase(NativeDatabase.memory()) {
    foods = DriftFoodRepository(database);
    recipes = DriftRecipeRepository(database);
    mealSlots = DriftMealSlotRepository(database);
    diary = DriftDiaryRepository(database);
    settings = DriftSettingsRepository(database);
    backup = DriftBackupRepository(
      database: database,
      foods: foods,
      recipes: recipes,
      mealSlots: mealSlots,
      diary: diary,
      settings: settings,
    );
  }

  final AppDatabase database;
  late final DriftFoodRepository foods;
  late final DriftRecipeRepository recipes;
  late final DriftMealSlotRepository mealSlots;
  late final DriftDiaryRepository diary;
  late final DriftSettingsRepository settings;
  late final DriftBackupRepository backup;

  Future<void> close() => database.close();
}

Food _food(String id) => Food(
  id: id,
  name: 'Food $id',
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(energyKcal: 100, carbohydrates: 20),
  createdAt: DateTime.utc(2026, 6, 19),
  updatedAt: DateTime.utc(2026, 6, 19),
);

void main() {
  late _Harness source;

  Future<void> seed(_Harness harness) async {
    await harness.foods.saveFood(_food('flour'));
    await harness.foods.saveFood(_food('sugar'));
    await harness.recipes.saveRecipe(
      Recipe(
        id: 'r1',
        name: 'Cake',
        yieldServings: 8,
        ingredients: [
          RecipeIngredient(foodId: 'flour', quantity: Quantity.grams(200)),
          RecipeIngredient(foodId: 'sugar', quantity: Quantity.grams(100)),
        ],
        createdAt: DateTime.utc(2026, 6, 19),
        updatedAt: DateTime.utc(2026, 6, 19),
      ),
    );
    await harness.mealSlots.saveMealSlot(
      const MealSlot(id: 'breakfast', name: 'Breakfast', position: 0),
    );
    await harness.diary.saveEntry(
      DiaryEntry(
        id: 'e1',
        day: DateTime.utc(2026, 6, 19),
        mealSlotId: 'breakfast',
        referenceKind: DiaryReferenceKind.food,
        referenceId: 'flour',
        label: 'Cake slice',
        quantity: Quantity.servings(1),
        nutrients: const Nutrients(energyKcal: 350),
        loggedAt: DateTime.utc(2026, 6, 19, 8),
      ),
    );
    await harness.settings.save(
      const AppSettings(
        unitSystem: UnitSystem.imperial,
        vdRegion: VdRegion.brazil,
        languageCode: 'pt',
        dailyTarget: Nutrients(energyKcal: 2000),
      ),
    );
  }

  setUp(() async {
    source = _Harness();
    await seed(source);
  });
  tearDown(() => source.close());

  test(
    'export then import on a fresh install reproduces every record (NFR-003)',
    () async {
      final exported = await source.backup.export();

      final fresh = _Harness();
      addTearDown(fresh.close);
      await fresh.backup.import(exported);

      expect(await fresh.foods.allFoods(), await source.foods.allFoods());
      expect(
        await fresh.recipes.allRecipes(),
        await source.recipes.allRecipes(),
      );
      expect(
        await fresh.mealSlots.allMealSlots(),
        await source.mealSlots.allMealSlots(),
      );
      expect(await fresh.diary.allEntries(), await source.diary.allEntries());
      expect(await fresh.settings.load(), await source.settings.load());
      // The re-exported JSON map is deeply equal (Map.== compares recursively
      // in Dart). This assertion uses integer-only test data so floating-point
      // round-trip precision is not a concern here -- if real doubles were
      // involved a tolerance-aware matcher would be needed.
      expect(await fresh.backup.export(), exported);
    },
  );

  test('round-trips an empty dataset', () async {
    final empty = _Harness();
    addTearDown(empty.close);

    final exported = await empty.backup.export();
    final restored = _Harness();
    addTearDown(restored.close);
    await restored.backup.import(exported);

    expect(await restored.foods.allFoods(), isEmpty);
    expect(await restored.recipes.allRecipes(), isEmpty);
    expect(await restored.diary.allEntries(), isEmpty);
    expect(await restored.settings.load(), AppSettings.defaults);
  });

  test('import replaces existing data rather than merging', () async {
    final exported = await source.backup.export();

    final other = _Harness();
    addTearDown(other.close);
    await other.foods.saveFood(_food('stale'));
    await other.mealSlots.saveMealSlot(
      const MealSlot(id: 'stale-slot', name: 'Stale', position: 9),
    );

    await other.backup.import(exported);

    final foods = await other.foods.allFoods();
    expect(foods.map((f) => f.id), unorderedEquals(['flour', 'sugar']));
    final slots = await other.mealSlots.allMealSlots();
    expect(slots.map((s) => s.id), ['breakfast']);
  });

  test(
    'rejects a malformed document and leaves the store untouched (FR-006)',
    () async {
      await expectLater(
        source.backup.import({'version': 'not-a-number'}),
        throwsA(isA<BackupFormatException>()),
      );

      expect(await source.foods.allFoods(), hasLength(2));
      expect(await source.diary.allEntries(), hasLength(1));
    },
  );

  test(
    'synchronous parse errors are rejected as the Future, not thrown',
    () async {
      // After the async fix, BackupFormatException from fromJson surfaces as a
      // Future rejection, not a synchronous throw -- this enables .catchError()
      // chaining and uniform error handling for all callers.
      var caught = false;
      await source.backup.import({'version': 999}).catchError((_) {
        caught = true;
      });
      expect(caught, isTrue);
      // The store was never touched (FR-006).
      expect(await source.foods.allFoods(), hasLength(2));
      expect(await source.diary.allEntries(), hasLength(1));
    },
  );

  test('a referential-integrity violation rolls back, preserving prior data '
      '(NFR-004)', () async {
    // A structurally valid backup whose diary entry references a meal slot
    // that the backup never defines.
    final broken = BackupDocument(
      version: BackupDocument.currentVersion,
      foods: [_food('flour')],
      recipes: const [],
      mealSlots: const [],
      diaryEntries: [
        DiaryEntry(
          id: 'orphan',
          day: DateTime.utc(2026, 6, 19),
          mealSlotId: 'ghost',
          referenceKind: DiaryReferenceKind.quickAdd,
          label: 'Orphan',
          quantity: Quantity.servings(1),
          nutrients: const Nutrients(energyKcal: 10),
          loggedAt: DateTime.utc(2026, 6, 19),
        ),
      ],
      settings: AppSettings.defaults,
    );

    await expectLater(
      source.backup.import(broken.toJson()),
      throwsA(isA<Exception>()),
    );

    // The original seeded dataset is fully intact: the wipe rolled back too.
    expect(await source.foods.allFoods(), hasLength(2));
    expect(await source.recipes.allRecipes(), hasLength(1));
    expect(await source.diary.allEntries(), hasLength(1));
    expect((await source.mealSlots.allMealSlots()).single.id, 'breakfast');
  });
}
