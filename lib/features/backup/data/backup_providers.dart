import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/database/database_providers.dart';
import 'package:opendiet/features/backup/data/drift_backup_repository.dart';
import 'package:opendiet/features/backup/domain/backup_repository.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';

/// The backup repository, backed by the on-device database and feature
/// repositories.
final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => DriftBackupRepository(
    database: ref.watch(appDatabaseProvider),
    foods: ref.watch(foodRepositoryProvider),
    recipes: ref.watch(recipeRepositoryProvider),
    mealSlots: ref.watch(mealSlotRepositoryProvider),
    diary: ref.watch(diaryRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
  ),
);
