import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/data/drift_food_repository.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:path/path.dart' as p;

Food _food(String id, {String? brand}) => Food(
  id: id,
  name: 'Food $id',
  brand: brand,
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(energyKcal: 100, protein: 10),
  servingSizeMetric: 50,
  servingUnit: ServingUnit.gram,
  householdMeasure: '1 scoop (50 g)',
  createdAt: DateTime.utc(2026, 6, 19, 8),
  updatedAt: DateTime.utc(2026, 6, 19, 8),
);

void main() {
  late AppDatabase database;
  late DriftFoodRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftFoodRepository(database);
  });
  tearDown(() => database.close());

  test('round-trips a food', () async {
    final food = _food('a', brand: 'Acme');

    await repository.saveFood(food);

    expect(await repository.findFood('a'), food);
  });

  test('a missing food reads back as null', () async {
    expect(await repository.findFood('nope'), isNull);
  });

  test('saving with an existing id updates rather than duplicates', () async {
    await repository.saveFood(_food('a', brand: 'Old'));
    await repository.saveFood(_food('a', brand: 'New'));

    final all = await repository.allFoods();
    expect(all, hasLength(1));
    expect(all.single.brand, 'New');
  });

  test('absent nutrients survive the round trip as null, not zero', () async {
    final food = _food('a').copyWith(nutrients: const Nutrients(energyKcal: 5));

    await repository.saveFood(food);

    expect((await repository.findFood('a'))!.nutrients.protein, isNull);
  });

  test('preserves the manual-energy flag across the round trip', () async {
    final food = _food('a').copyWith(energyIsManual: true);

    await repository.saveFood(food);

    expect((await repository.findFood('a'))!.energyIsManual, isTrue);
  });

  test('deleteFood removes the food', () async {
    await repository.saveFood(_food('a'));

    await repository.deleteFood('a');

    expect(await repository.findFood('a'), isNull);
  });

  test('toggleFavorite flips isFavorite from false to true', () async {
    await repository.saveFood(_food('a'));

    await repository.toggleFavorite('a');

    expect((await repository.findFood('a'))!.isFavorite, isTrue);
  });

  test('toggleFavorite flips isFavorite from true to false', () async {
    await repository.saveFood(_food('a').copyWith(isFavorite: true));

    await repository.toggleFavorite('a');

    expect((await repository.findFood('a'))!.isFavorite, isFalse);
  });

  test('toggleFavorite does nothing for a non-existent food', () async {
    await repository.toggleFavorite('nope');

    // No exception should be thrown.
    expect(true, isTrue);
  });

  test('markLastLoggedAt sets the timestamp', () async {
    final now = DateTime.utc(2026, 6, 20, 15);
    await repository.saveFood(_food('a'));

    await repository.markLastLoggedAt('a', now);

    expect((await repository.findFood('a'))!.lastLoggedAt, now);
  });

  test('markLastLoggedAt does nothing for a non-existent food', () async {
    await repository.markLastLoggedAt('nope', DateTime.utc(2026));

    // No exception should be thrown.
    expect(true, isTrue);
  });

  group('Persistence across reopen (FR-001)', () {
    // The same file is opened twice, sequentially, after closing the first.
    setUp(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
    tearDown(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = false);

    test('data written in one session is present after reopening', () async {
      final directory = await Directory.systemTemp.createTemp('opendiet_db');
      final file = File(p.join(directory.path, 'opendiet.sqlite'));
      final food = _food('persisted');

      var persistent = AppDatabase(NativeDatabase(file));
      await DriftFoodRepository(persistent).saveFood(food);
      await persistent.close();

      persistent = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await persistent.close();
        await directory.delete(recursive: true);
      });

      expect(await DriftFoodRepository(persistent).findFood('persisted'), food);
    });
  });
}
