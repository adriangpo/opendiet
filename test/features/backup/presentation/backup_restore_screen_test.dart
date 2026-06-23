import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/backup/data/backup_providers.dart';
import 'package:opendiet/features/backup/domain/backup_document.dart';
import 'package:opendiet/features/backup/domain/backup_repository.dart';
import 'package:opendiet/features/backup/presentation/backup_file_gateway.dart';
import 'package:opendiet/features/backup/presentation/backup_restore_screen.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';

import '../../../support/fake_diary_repository.dart';
import '../../../support/fake_food_repository.dart';
import '../../../support/fake_meal_slot_repository.dart';
import '../../../support/fake_recipe_repository.dart';
import '../../../support/test_app.dart';

void main() {
  testWidgets('exports a backup and shows the saved file state', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(savedPath: 'opendiet-backup.json');
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    expect(find.text('Last export: never'), findsOneWidget);

    await tester.tap(find.text('Export backup'));
    await tester.pump();
    await tester.pump();

    expect(repository.exportCount, 1);
    expect(files.savedJson, repository.exportJson);
    expect(
      find.text('Backup exported to opendiet-backup.json.'),
      findsOneWidget,
    );
    expect(find.text('Last export: opendiet-backup.json'), findsOneWidget);
  });

  testWidgets('keeps export available after a save failure', (tester) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(saveError: Exception('Disk full'));
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Export backup'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('Could not export backup. Try another location.'),
      findsOneWidget,
    );
    expect(find.text('Export backup'), findsOneWidget);
  });

  testWidgets('asks for confirmation before restoring from a file', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(importJson: const {'version': 1});
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Restore from file'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Replace current data?'), findsOneWidget);
    expect(repository.importCount, 0);

    await tester.tap(find.text('Restore'));
    await tester.pump();
    await tester.pump();

    expect(repository.importCount, 1);
    expect(repository.importedJson, const {'version': 1});
    expect(find.text('Backup restored.'), findsOneWidget);
  });

  testWidgets('refreshes active database-backed providers after restore', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(importJson: const {'version': 1});
    final mealSlots = CountingMealSlotRepository();
    final diary = CountingDiaryRepository();
    final foods = CountingFoodRepository();
    final recipes = CountingRecipeRepository();

    await pumpApp(
      tester,
      const _WatchedBackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
        mealSlotRepositoryProvider.overrideWithValue(mealSlots),
        diaryRepositoryProvider.overrideWithValue(diary),
        foodRepositoryProvider.overrideWithValue(foods),
        recipeRepositoryProvider.overrideWithValue(recipes),
      ],
    );

    expect(mealSlots.allMealSlotsCount, 1);
    expect(diary.entriesForDayCount, 1);
    expect(foods.watchAllFoodsCount, 3);
    expect(recipes.allRecipesCount, 1);

    await tester.tap(find.text('Restore from file'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Restore'));
    await tester.pump();
    await tester.pump();

    expect(repository.importCount, 1);
    expect(mealSlots.allMealSlotsCount, 2);
    expect(diary.entriesForDayCount, 2);
    expect(foods.watchAllFoodsCount, 6);
    expect(recipes.allRecipesCount, 2);
  });

  testWidgets('canceling the restore confirmation leaves data untouched', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(importJson: const {'version': 1});
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Restore from file'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pump();

    expect(repository.importCount, 0);
    expect(find.text('Restore from file'), findsOneWidget);
  });

  testWidgets('rejects malformed backup files without restoring', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(
      importError: const BackupFormatException('Invalid JSON.'),
    );
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Restore from file'));
    await tester.pump();
    await tester.pump();

    expect(repository.importCount, 0);
    expect(
      find.text(
        'Backup file is malformed or incompatible. No data was changed.',
      ),
      findsOneWidget,
    );
  });
}

class FakeBackupRepository implements BackupRepository {
  final Map<String, Object?> exportJson = <String, Object?>{
    'version': BackupDocument.currentVersion,
    'foods': <Object?>[],
    'recipes': <Object?>[],
    'mealSlots': <Object?>[],
    'diaryEntries': <Object?>[],
    'settings': <String, Object?>{},
  };

  int exportCount = 0;
  int importCount = 0;
  Map<String, Object?>? importedJson;

  @override
  Future<Map<String, Object?>> export() async {
    exportCount++;
    return exportJson;
  }

  @override
  Future<void> import(Map<String, Object?> json) async {
    importCount++;
    importedJson = json;
  }
}

class _WatchedBackupRestoreScreen extends ConsumerWidget {
  const _WatchedBackupRestoreScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(mealSlotsProvider)
      ..watch(selectedDayEntriesProvider)
      ..watch(foodListProvider)
      ..watch(recentFoodsProvider)
      ..watch(favoriteFoodsProvider)
      ..watch(recipeListProvider);
    return const BackupRestoreScreen();
  }
}

class CountingMealSlotRepository extends FakeMealSlotRepository {
  int allMealSlotsCount = 0;

  @override
  Future<List<MealSlot>> allMealSlots() {
    allMealSlotsCount++;
    return super.allMealSlots();
  }
}

class CountingDiaryRepository extends FakeDiaryRepository {
  int entriesForDayCount = 0;

  @override
  Future<List<DiaryEntry>> entriesForDay(DateTime day) {
    entriesForDayCount++;
    return super.entriesForDay(day);
  }
}

class CountingFoodRepository extends FakeFoodRepository {
  int watchAllFoodsCount = 0;

  @override
  Stream<List<Food>> watchAllFoods() {
    watchAllFoodsCount++;
    return super.watchAllFoods();
  }
}

class CountingRecipeRepository extends FakeRecipeRepository {
  int allRecipesCount = 0;

  @override
  Future<List<Recipe>> allRecipes() {
    allRecipesCount++;
    return super.allRecipes();
  }
}

class FakeBackupFileGateway implements BackupFileGateway {
  FakeBackupFileGateway({
    this.savedPath,
    this.importJson,
    this.saveError,
    this.importError,
  });

  final String? savedPath;
  final Map<String, Object?>? importJson;
  final Exception? saveError;
  final Exception? importError;
  Map<String, Object?>? savedJson;

  @override
  Future<Map<String, Object?>?> pickJsonBackup() async {
    final error = importError;
    if (error != null) throw error;
    return importJson;
  }

  @override
  Future<String?> saveJsonBackup({
    required String fileName,
    required Map<String, Object?> json,
  }) async {
    final error = saveError;
    if (error != null) throw error;
    savedJson = json;
    return savedPath;
  }
}
