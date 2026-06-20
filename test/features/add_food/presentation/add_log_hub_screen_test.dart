import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/test_app.dart';

void main() {
  List<Override> baseOverrides(String route) => [
    foodRepositoryProvider.overrideWithValue(FakeFoodRepository()),
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
          ...baseOverrides('/diary/add/s1'),
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
          ...baseOverrides('/diary/add/s1'),
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
          ...baseOverrides('/diary/add/s1'),
        ],
        initialRoute: '/diary/add/s1',
      );

      expect(find.text('Add Food'), findsOneWidget);
    });

    testWidgets('shows Create custom food button', (tester) async {
      await pumpAppShell(
        tester,
        overrides: [
          ...baseOverrides('/diary/add/s1'),
        ],
        initialRoute: '/diary/add/s1',
      );

      expect(find.text('Create custom food'), findsOneWidget);
    });
  });
}
