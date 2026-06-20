import 'package:drift/drift.dart';
import 'package:opendiet/core/database/converters.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/foods/domain/food.dart';

// Enum columns persist the enum index; their declaration order is therefore
// part of the schema and must not be reordered without a migration.

/// Foods: custom, imported, or Open-Food-Facts-sourced (FR-001, FR-008).
@DataClassName('FoodRow')
class Foods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get barcode => text().nullable()();
  IntColumn get source => intEnum<FoodSource>()();
  IntColumn get basis => intEnum<NutrientBasis>()();
  TextColumn get nutrients => text().map(const NutrientsConverter())();
  RealColumn get servingSizeMetric => real().nullable()();
  IntColumn get servingUnit => intEnum<ServingUnit>().nullable()();
  TextColumn get householdMeasure => text().nullable()();
  BoolColumn get energyIsManual =>
      boolean().withDefault(const Constant(false))();
  IntColumn get lastLoggedAt =>
      integer().map(const DateTimeMillisConverter()).nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer().map(const DateTimeMillisConverter())();
  IntColumn get updatedAt => integer().map(const DateTimeMillisConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Recipes: composed of ingredients with a yield (FR-015).
@DataClassName('RecipeRow')
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get yieldServings => real()();
  IntColumn get createdAt => integer().map(const DateTimeMillisConverter())();
  IntColumn get updatedAt => integer().map(const DateTimeMillisConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Recipe ingredient lines; deleting a recipe cascades to its lines, and an
/// ingredient must reference an existing food (FR-023).
@DataClassName('RecipeIngredientRow')
class RecipeIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recipeId =>
      text().references(Recipes, #id, onDelete: KeyAction.cascade)();
  TextColumn get foodId =>
      text().references(Foods, #id, onDelete: KeyAction.restrict)();
  RealColumn get quantityAmount => real()();
  IntColumn get quantityMeasure => intEnum<QuantityMeasure>()();
  IntColumn get position => integer()();
}

/// User-defined meal slots the diary is grouped into (FR-019).
@DataClassName('MealSlotRow')
class MealSlots extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Diary entries; each must reference an existing meal slot (FR-023).
@DataClassName('DiaryEntryRow')
class DiaryEntries extends Table {
  TextColumn get id => text()();
  IntColumn get day => integer().map(const DateTimeMillisConverter())();
  TextColumn get mealSlotId =>
      text().references(MealSlots, #id, onDelete: KeyAction.restrict)();
  IntColumn get referenceKind => intEnum<DiaryReferenceKind>()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get label => text()();
  RealColumn get quantityAmount => real()();
  IntColumn get quantityMeasure => intEnum<QuantityMeasure>()();
  TextColumn get nutrients => text().map(const NutrientsConverter())();
  IntColumn get loggedAt => integer().map(const DateTimeMillisConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Mealtime reminders; each has a time, an enabled flag, and an optional
/// reference to a meal slot (FR-020).
@DataClassName('ReminderRow')
class Reminders extends Table {
  TextColumn get id => text()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  BoolColumn get enabled => boolean()();
  TextColumn get mealSlotId => text()
      .references(MealSlots, #id, onDelete: KeyAction.setNull)
      .nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The single profile's settings; pinned to one row (FR-022, FR-024, FR-027).
@DataClassName('AppSettingsRow')
class AppSettingsRows extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get unitSystem => intEnum<UnitSystem>()();
  IntColumn get vdRegion => intEnum<VdRegion>()();
  TextColumn get languageCode => text().nullable()();
  TextColumn get dailyTarget =>
      text().map(const NutrientsConverter()).nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
