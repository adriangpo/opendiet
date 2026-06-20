import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/features/diary/data/drift_meal_slot_repository.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';

MealSlot _slot(String id, int position) =>
    MealSlot(id: id, name: 'Slot $id', position: position);

void main() {
  late AppDatabase database;
  late DriftMealSlotRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftMealSlotRepository(database);
  });
  tearDown(() => database.close());

  test('returns slots ordered by position', () async {
    await repository.saveMealSlot(_slot('dinner', 2));
    await repository.saveMealSlot(_slot('breakfast', 0));
    await repository.saveMealSlot(_slot('lunch', 1));

    final slots = await repository.allMealSlots();

    expect(slots.map((slot) => slot.id), ['breakfast', 'lunch', 'dinner']);
  });

  test('deleteMealSlot removes the slot', () async {
    await repository.saveMealSlot(_slot('breakfast', 0));

    await repository.deleteMealSlot('breakfast');

    expect(await repository.allMealSlots(), isEmpty);
  });
}
