import 'package:drift/drift.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/diary/domain/meal_slot_repository.dart';

/// Drift-backed [MealSlotRepository].
class DriftMealSlotRepository implements MealSlotRepository {
  /// Creates a repository over [_database].
  DriftMealSlotRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> saveMealSlot(MealSlot slot) => _database
      .into(_database.mealSlots)
      .insertOnConflictUpdate(
        MealSlotsCompanion(
          id: Value(slot.id),
          name: Value(slot.name),
          position: Value(slot.position),
        ),
      );

  @override
  Future<List<MealSlot>> allMealSlots() async {
    final rows = await (_database.select(
      _database.mealSlots,
    )..orderBy([(row) => OrderingTerm(expression: row.position)])).get();
    return rows
        .map(
          (row) => MealSlot(id: row.id, name: row.name, position: row.position),
        )
        .toList();
  }

  @override
  Future<void> deleteMealSlot(String id) => (_database.delete(
    _database.mealSlots,
  )..where((row) => row.id.equals(id))).go();
}
