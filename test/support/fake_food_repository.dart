import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_repository.dart';

/// An in-memory [FoodRepository] for widget tests that records what was saved.
class FakeFoodRepository implements FoodRepository {
  /// Every food passed to [saveFood], in order.
  final List<Food> savedFoods = [];

  /// The most recently saved food, or null when nothing was saved.
  Food? get lastSaved => savedFoods.isEmpty ? null : savedFoods.last;

  @override
  Future<void> saveFood(Food food) async => savedFoods.add(food);

  @override
  Future<Food?> findFood(String id) async {
    for (final food in savedFoods.reversed) {
      if (food.id == id) return food;
    }
    return null;
  }

  @override
  Future<List<Food>> allFoods() async => List.of(savedFoods);

  @override
  Future<void> deleteFood(String id) async =>
      savedFoods.removeWhere((food) => food.id == id);
}
