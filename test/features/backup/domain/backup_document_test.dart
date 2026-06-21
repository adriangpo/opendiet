import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/features/backup/domain/backup_document.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';

void main() {
  final food = Food(
    id: 'f1',
    name: 'Oats',
    source: FoodSource.custom,
    basis: NutrientBasis.per100g,
    nutrients: const Nutrients(energyKcal: 389, carbohydrates: 66),
    createdAt: DateTime.utc(2026, 6, 19),
    updatedAt: DateTime.utc(2026, 6, 19),
  );
  final recipe = Recipe(
    id: 'r1',
    name: 'Porridge',
    yieldServings: 2,
    ingredients: [RecipeIngredient(foodId: 'f1', quantity: Quantity.grams(80))],
    createdAt: DateTime.utc(2026, 6, 19),
    updatedAt: DateTime.utc(2026, 6, 19),
  );
  const slot = MealSlot(id: 'breakfast', name: 'Breakfast', position: 0);
  final entry = DiaryEntry(
    id: 'e1',
    day: DateTime.utc(2026, 6, 19),
    mealSlotId: 'breakfast',
    referenceKind: DiaryReferenceKind.food,
    referenceId: 'f1',
    label: 'Oats',
    quantity: Quantity.grams(40),
    nutrients: const Nutrients(energyKcal: 156),
    loggedAt: DateTime.utc(2026, 6, 19, 8),
  );
  const settings = AppSettings(
    unitSystem: UnitSystem.imperial,
    vdRegion: VdRegion.brazil,
    languageCode: 'pt',
    dailyTarget: Nutrients(energyKcal: 2000),
  );

  BackupDocument document() => BackupDocument(
    version: BackupDocument.currentVersion,
    foods: [food],
    recipes: [recipe],
    mealSlots: const [slot],
    diaryEntries: [entry],
    settings: settings,
  );

  test('round-trips every entity through JSON unchanged', () {
    final restored = BackupDocument.fromJson(document().toJson());

    expect(restored.version, BackupDocument.currentVersion);
    expect(restored.foods, [food]);
    expect(restored.recipes, [recipe]);
    expect(restored.mealSlots, const [slot]);
    expect(restored.diaryEntries, [entry]);
    expect(restored.settings, settings);
  });

  test('survives a full JSON encode/decode cycle', () {
    final encoded = jsonEncode(document().toJson());
    final decoded = jsonDecode(encoded) as Map<String, dynamic>;

    final restored = BackupDocument.fromJson(decoded);

    expect(restored.recipes.single.ingredients.single.foodId, 'f1');
    expect(restored.settings.dailyTarget?.energyKcal, 2000);
  });

  test('round-trips an empty dataset with default settings', () {
    const empty = BackupDocument(
      version: BackupDocument.currentVersion,
      foods: [],
      recipes: [],
      mealSlots: [],
      diaryEntries: [],
      settings: AppSettings.defaults,
    );

    final restored = BackupDocument.fromJson(empty.toJson());

    expect(restored.foods, isEmpty);
    expect(restored.recipes, isEmpty);
    expect(restored.mealSlots, isEmpty);
    expect(restored.diaryEntries, isEmpty);
    expect(restored.settings, AppSettings.defaults);
  });

  group('rejects a malformed document', () {
    test('missing version', () {
      final json = document().toJson()..remove('version');
      expect(
        () => BackupDocument.fromJson(json),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('unsupported version', () {
      final json = document().toJson()..['version'] = 999;
      expect(
        () => BackupDocument.fromJson(json),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('a collection field that is not a list', () {
      final json = document().toJson()..['foods'] = 'not-a-list';
      expect(
        () => BackupDocument.fromJson(json),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('a record with the wrong shape', () {
      final json = document().toJson()
        ..['foods'] = [
          {'id': 'broken'},
        ];
      expect(
        () => BackupDocument.fromJson(json),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('a non-object element inside a collection', () {
      final json = document().toJson()..['mealSlots'] = [42];
      expect(
        () => BackupDocument.fromJson(json),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('settings that are not an object', () {
      final json = document().toJson()..['settings'] = <Object>[];
      expect(
        () => BackupDocument.fromJson(json),
        throwsA(isA<BackupFormatException>()),
      );
    });
  });
}
