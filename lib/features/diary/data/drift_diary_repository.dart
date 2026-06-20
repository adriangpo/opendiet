import 'package:drift/drift.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/core/database/converters.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/diary_repository.dart';

/// Drift-backed [DiaryRepository].
class DriftDiaryRepository implements DiaryRepository {
  /// Creates a repository over [_database].
  DriftDiaryRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> saveEntry(DiaryEntry entry) => _database
      .into(_database.diaryEntries)
      .insertOnConflictUpdate(
        DiaryEntriesCompanion(
          id: Value(entry.id),
          day: Value(entry.day),
          mealSlotId: Value(entry.mealSlotId),
          referenceKind: Value(entry.referenceKind),
          referenceId: Value(entry.referenceId),
          label: Value(entry.label),
          quantityAmount: Value(entry.quantity.amount),
          quantityMeasure: Value(entry.quantity.measure),
          nutrients: Value(entry.nutrients),
          loggedAt: Value(entry.loggedAt),
        ),
      );

  @override
  Future<DiaryEntry?> findEntry(String id) async {
    final row = await (_database.select(
      _database.diaryEntries,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<List<DiaryEntry>> entriesForDay(DateTime day) async {
    const converter = DateTimeMillisConverter();
    final start = converter.toSql(DateTime.utc(day.year, day.month, day.day));
    final end = start + const Duration(days: 1).inMilliseconds;
    final rows =
        await (_database.select(_database.diaryEntries)
              ..where(
                (row) =>
                    row.day.isBiggerOrEqualValue(start) &
                    row.day.isSmallerThanValue(end),
              )
              ..orderBy([(row) => OrderingTerm(expression: row.id)]))
            .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> deleteEntry(String id) => (_database.delete(
    _database.diaryEntries,
  )..where((row) => row.id.equals(id))).go();

  DiaryEntry _toDomain(DiaryEntryRow row) => DiaryEntry(
    id: row.id,
    day: row.day,
    mealSlotId: row.mealSlotId,
    referenceKind: row.referenceKind,
    referenceId: row.referenceId,
    label: row.label,
    quantity: Quantity(
      amount: row.quantityAmount,
      measure: row.quantityMeasure,
    ),
    nutrients: row.nutrients,
    loggedAt: row.loggedAt,
  );
}
