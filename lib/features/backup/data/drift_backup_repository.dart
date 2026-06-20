import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/features/backup/domain/backup_document.dart';
import 'package:opendiet/features/backup/domain/backup_repository.dart';
import 'package:opendiet/features/diary/domain/diary_repository.dart';
import 'package:opendiet/features/diary/domain/meal_slot_repository.dart';
import 'package:opendiet/features/foods/domain/food_repository.dart';
import 'package:opendiet/features/recipes/domain/recipe_repository.dart';
import 'package:opendiet/features/settings/domain/settings_repository.dart';

/// Drift-backed [BackupRepository].
///
/// Export reads through the feature repositories so each entity's row mapping
/// stays in one place. Restore wraps the wipe and re-insert in a single
/// database transaction, so a referential-integrity failure rolls the entire
/// restore back -- the wipe included -- and previously committed data survives
/// (FR-006, NFR-004).
class DriftBackupRepository implements BackupRepository {
  /// Creates a repository over [database] and the feature repositories.
  DriftBackupRepository({
    required AppDatabase database,
    required FoodRepository foods,
    required RecipeRepository recipes,
    required MealSlotRepository mealSlots,
    required DiaryRepository diary,
    required SettingsRepository settings,
  }) : _database = database,
       _foods = foods,
       _recipes = recipes,
       _mealSlots = mealSlots,
       _diary = diary,
       _settings = settings;

  final AppDatabase _database;
  final FoodRepository _foods;
  final RecipeRepository _recipes;
  final MealSlotRepository _mealSlots;
  final DiaryRepository _diary;
  final SettingsRepository _settings;

  @override
  Future<Map<String, dynamic>> export() async {
    final document = BackupDocument(
      version: BackupDocument.currentVersion,
      foods: await _foods.allFoods(),
      recipes: await _recipes.allRecipes(),
      mealSlots: await _mealSlots.allMealSlots(),
      diaryEntries: await _diary.allEntries(),
      settings: await _settings.load(),
    );
    return document.toJson();
  }

  @override
  Future<void> import(Map<String, dynamic> json) async {
    // Parse and validate the whole document before touching the store, so a
    // malformed backup is rejected without any write (FR-006).
    final document = BackupDocument.fromJson(json);
    await _database.transaction(() async {
      await _wipe();
      // Insert in dependency order: a recipe ingredient references a food and a
      // diary entry references a meal slot, so parents land before children.
      for (final food in document.foods) {
        await _foods.saveFood(food);
      }
      for (final recipe in document.recipes) {
        await _recipes.saveRecipe(recipe);
      }
      for (final slot in document.mealSlots) {
        await _mealSlots.saveMealSlot(slot);
      }
      await _settings.save(document.settings);
      for (final entry in document.diaryEntries) {
        await _diary.saveEntry(entry);
      }
    });
  }

  /// Empties every table, in an order that respects the foreign keys that
  /// restrict deletion (children before parents).
  Future<void> _wipe() async {
    await _database.delete(_database.diaryEntries).go();
    await _database.delete(_database.recipeIngredients).go();
    await _database.delete(_database.recipes).go();
    await _database.delete(_database.mealSlots).go();
    await _database.delete(_database.foods).go();
    await _database.delete(_database.appSettingsRows).go();
  }
}
