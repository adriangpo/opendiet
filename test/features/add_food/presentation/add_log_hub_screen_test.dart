import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/widgets/food_list_tile.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/diary_repository.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides({
    FakeFoodRepository? foodRepository,
    _FakeDiaryRepository? diaryRepository,
  }) => [
    foodRepositoryProvider.overrideWithValue(
      foodRepository ?? FakeFoodRepository(),
    ),
    diaryRepositoryProvider.overrideWithValue(
      diaryRepository ?? _FakeDiaryRepository(),
    ),
    idGeneratorProvider.overrideWithValue(_FixedIdGenerator('entry-1')),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
    clockProvider.overrideWithValue(
      FixedClock(DateTime.utc(2026, 6, 20)),
    ),
    mealSlotsProvider.overrideWithValue(
      const AsyncData([
        MealSlot(id: 's1', name: 'Breakfast', position: 0),
      ]),
    ),
  ];

  group('AddLogHubScreen', () {
    testWidgets('shows segments Recent, Favorites, Foods', (tester) async {
      await pumpAppShell(
        tester,
        overrides: [
          ...baseOverrides(),
        ],
        initialRoute: '/diary/add/s1',
      );

      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Foods'), findsNWidgets(2));
    });

    testWidgets('shows recents empty state when no foods logged', (
      tester,
    ) async {
      await pumpAppShell(
        tester,
        overrides: [
          ...baseOverrides(),
        ],
        initialRoute: '/diary/add/s1',
      );

      expect(
        find.text('No recently logged foods yet.'),
        findsOneWidget,
      );
    });

    testWidgets('shows Add Food title', (tester) async {
      await pumpAppShell(
        tester,
        overrides: [
          ...baseOverrides(),
        ],
        initialRoute: '/diary/add/s1',
      );

      expect(find.text('Add Food'), findsOneWidget);
    });

    testWidgets('shows Create custom food button', (tester) async {
      await pumpAppShell(
        tester,
        overrides: [
          ...baseOverrides(),
        ],
        initialRoute: '/diary/add/s1',
      );

      expect(find.text('Create custom food'), findsOneWidget);
    });

    testWidgets(
      'quick-logs a per-100g food without serving size as 100 grams',
      (tester) async {
        final foods = FakeFoodRepository();
        final diary = _FakeDiaryRepository();
        await foods.saveFood(
          _food(
            'rice',
            lastLoggedAt: DateTime.utc(2026, 6, 19),
          ),
        );

        await pumpAppShell(
          tester,
          overrides: [
            ...baseOverrides(
              foodRepository: foods,
              diaryRepository: diary,
            ),
          ],
          initialRoute: '/diary/add/s1',
        );

        final quickLogButton = tester.widget<IconButton>(
          find.descendant(
            of: find.byType(FoodListTile),
            matching: find.byType(IconButton),
          ),
        );
        quickLogButton.onPressed!();
        await tester.pump();
        await tester.pump();

        expect(diary.savedEntries, hasLength(1));
        expect(diary.savedEntries.single.quantity, Quantity.grams(100));
        expect(diary.savedEntries.single.nutrients.energyKcal, 130);
        expect(
          (await foods.findFood('rice'))!.lastLoggedAt,
          DateTime.utc(2026, 6, 20),
        );
      },
    );
  });
}

Food _food(String id, {DateTime? lastLoggedAt}) => Food(
  id: id,
  name: 'Rice',
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(energyKcal: 130),
  createdAt: DateTime.utc(2026, 6, 19),
  updatedAt: DateTime.utc(2026, 6, 19),
  lastLoggedAt: lastLoggedAt,
);

class _FixedIdGenerator implements IdGenerator {
  _FixedIdGenerator(this._id);

  final String _id;

  @override
  String newId() => _id;
}

class _FakeDiaryRepository implements DiaryRepository {
  final List<DiaryEntry> savedEntries = [];

  @override
  Future<void> saveEntry(DiaryEntry entry) async {
    savedEntries.add(entry);
  }

  @override
  Future<DiaryEntry?> findEntry(String id) async {
    for (final entry in savedEntries.reversed) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  @override
  Future<List<DiaryEntry>> entriesForDay(DateTime day) async =>
      savedEntries.where((entry) => entry.day == day).toList();

  @override
  Future<List<DiaryEntry>> allEntries() async => List.of(savedEntries);

  @override
  Future<void> deleteEntry(String id) async {
    savedEntries.removeWhere((entry) => entry.id == id);
  }
}
