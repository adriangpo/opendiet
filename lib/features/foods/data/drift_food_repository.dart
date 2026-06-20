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
  Future<List<Food>> allFoods() async {
    final query = _database.select(_database.foods)
      ..orderBy([(table) => OrderingTerm(expression: table.id)]);
    return (await query.get()).map(_toDomain).toList();
  }

  @override
  Stream<List<Food>> watchAllFoods() {
    final query = _database.select(_database.foods)
      ..orderBy([(table) => OrderingTerm(expression: table.id)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<List<Food>> searchFoods(String query) async {
    final pattern = '%${query.toLowerCase()}%';
    final queryBuilder = _database.select(_database.foods)
      ..where((row) => row.name.lower().like(pattern));
    return (await queryBuilder.get()).map(_toDomain).toList();
  }

  @override
  Future<void> deleteFood(String id) => (_database.delete(
    _database.foods,
  )..where((row) => row.id.equals(id))).go();

  @override
  Future<void> toggleFavorite(String id) async {
    final food = await findFood(id);
    if (food == null) return;
    await saveFood(food.copyWith(isFavorite: !food.isFavorite));
  }

  @override
  Future<void> markLastLoggedAt(String id, DateTime at) async {
    final food = await findFood(id);
    if (food == null) return;
    await saveFood(food.copyWith(lastLoggedAt: at));
  }

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
    lastLoggedAt: Value(food.lastLoggedAt),
    isFavorite: Value(food.isFavorite),
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
    lastLoggedAt: row.lastLoggedAt,
    isFavorite: row.isFavorite,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
