import 'package:drift/drift.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/food_repository.dart';

/// Drift-backed [FoodRepository]. Owns the foods-to-rows mapping.
class DriftFoodRepository implements FoodRepository {
  /// Creates a repository over [_database].
  DriftFoodRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> saveFood(Food food) => _database
      .into(_database.foods)
      .insertOnConflictUpdate(_toCompanion(food));

  @override
  Future<Food?> findFood(String id) async {
    final row = await (_database.select(
      _database.foods,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<List<Food>> allFoods() async =>
      (await _database.select(_database.foods).get()).map(_toDomain).toList();

  @override
  Future<void> deleteFood(String id) => (_database.delete(
    _database.foods,
  )..where((row) => row.id.equals(id))).go();

  FoodsCompanion _toCompanion(Food food) => FoodsCompanion(
    id: Value(food.id),
    name: Value(food.name),
    brand: Value(food.brand),
    barcode: Value(food.barcode),
    source: Value(food.source),
    basis: Value(food.basis),
    nutrients: Value(food.nutrients),
    servingSizeMetric: Value(food.servingSizeMetric),
    servingUnit: Value(food.servingUnit),
    householdMeasure: Value(food.householdMeasure),
    energyIsManual: Value(food.energyIsManual),
    createdAt: Value(food.createdAt),
    updatedAt: Value(food.updatedAt),
  );

  Food _toDomain(FoodRow row) => Food(
    id: row.id,
    name: row.name,
    brand: row.brand,
    barcode: row.barcode,
    source: row.source,
    basis: row.basis,
    nutrients: row.nutrients,
    servingSizeMetric: row.servingSizeMetric,
    servingUnit: row.servingUnit,
    householdMeasure: row.householdMeasure,
    energyIsManual: row.energyIsManual,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
