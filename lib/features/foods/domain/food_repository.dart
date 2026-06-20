import 'package:opendiet/features/foods/domain/food.dart';

/// Persists and retrieves foods (FR-001, FR-008).
///
/// The rest of the app depends on this interface, never on the concrete store
/// (see AGENTS.md). Custom, imported, and Open-Food-Facts foods all flow
/// through it.
abstract interface class FoodRepository {
  /// Inserts or updates [food].
  Future<void> saveFood(Food food);

  /// The food with [id], or null when absent.
  Future<Food?> findFood(String id);

  /// Every stored food.
  Future<List<Food>> allFoods();

  /// Emits the current food list on each change.
  Stream<List<Food>> watchAllFoods();

  /// Removes the food with [id].
  Future<void> deleteFood(String id);
}
