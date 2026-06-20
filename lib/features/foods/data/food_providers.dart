import 'package:opendiet/core/database/database_providers.dart';
import 'package:opendiet/features/foods/data/drift_food_repository.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_providers.g.dart';

/// The food repository, backed by the on-device database.
@Riverpod(keepAlive: true)
FoodRepository foodRepository(Ref ref) =>
    DriftFoodRepository(ref.watch(appDatabaseProvider));

/// The list of all saved foods, kept in sync via the repository stream.
@riverpod
Stream<List<Food>> foodList(Ref ref) =>
    ref.watch(foodRepositoryProvider).watchAllFoods();

/// Foods sorted by [Food.lastLoggedAt] descending, limited to 20 (FR-018).
@riverpod
Stream<List<Food>> recentFoods(Ref ref) {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.watchAllFoods().map(
    (foods) =>
        foods.where((f) => f.lastLoggedAt != null).toList()
          ..sort((a, b) => b.lastLoggedAt!.compareTo(a.lastLoggedAt!)),
  );
}

/// Foods where [Food.isFavorite] is true (FR-018).
@riverpod
Stream<List<Food>> favoriteFoods(Ref ref) {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.watchAllFoods().map(
    (foods) => foods.where((f) => f.isFavorite).toList(),
  );
}
