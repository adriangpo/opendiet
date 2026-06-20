import 'package:drift/drift.dart';
import 'package:opendiet/core/database/converters.dart';
import 'package:opendiet/core/database/tables.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/foods/domain/food.dart';

part 'app_database.g.dart';

/// The on-device store schema and connection (FR-001).
///
/// This class owns only the tables and the database wiring (schema version,
/// migration, foreign-key enforcement). Reading and writing each entity lives
/// behind a feature repository (see `lib/features/<feature>/data`), so the rest
/// of the app depends on a domain interface, never on Drift directly.
///
/// Foreign keys are enforced; repositories run multi-record writes in
/// transactions, so a rejected write leaves prior committed data unchanged
/// (FR-023, NFR-004).
@DriftDatabase(
  tables: [
    Foods,
    Recipes,
    RecipeIngredients,
    MealSlots,
    DiaryEntries,
    AppSettingsRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the database on [executor].
  // The generated base constructor names its parameter 'e'; keep the readable
  // name here rather than match the abbreviation.
  // ignore: matching_super_parameters
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
