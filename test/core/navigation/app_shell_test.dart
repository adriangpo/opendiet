import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../support/fake_food_repository.dart';
import '../../support/fake_meal_slot_repository.dart';
import '../../support/fake_settings_repository.dart';
import '../../support/test_app.dart';

void main() {
  List<Override> overrides() => [
    foodRepositoryProvider.overrideWithValue(FakeFoodRepository()),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
    mealSlotsProvider.overrideWithValue(const AsyncData([])),
  ];

  testWidgets('renders the four bottom-navigation tabs', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    expect(find.widgetWithText(NavigationDestination, 'Diary'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Foods'), findsOneWidget);
    expect(
      find.widgetWithText(NavigationDestination, 'Recipes'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(NavigationDestination, 'Settings'),
      findsOneWidget,
    );
  });

  testWidgets('starts on the Diary tab', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    expect(
      find.text('No entries yet. Log a food to start your day.'),
      findsOneWidget,
    );
  });

  testWidgets('switches to the Foods tab when tapped', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Foods'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('No foods yet. Create a custom food or import a list.'),
      findsOneWidget,
    );
  });

  testWidgets('shows the settings controls on the Settings tab', (
    tester,
  ) async {
    await pumpAppShell(tester, overrides: overrides());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Unit system'), findsOneWidget);
    expect(find.text('%VD reference'), findsOneWidget);
  });

  testWidgets('opens the food editor from the Foods tab', (tester) async {
    await pumpAppShell(tester, overrides: overrides());

    await tester.tap(find.widgetWithText(NavigationDestination, 'Foods'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('field-name')), findsOneWidget);
  });

  testWidgets('opens the meal slots settings route', (tester) async {
    final mealSlots = FakeMealSlotRepository();
    await mealSlots.saveMealSlot(
      const MealSlot(id: 'breakfast', name: 'Breakfast', position: 0),
    );
    await pumpAppShell(
      tester,
      overrides: [
        ...overrides(),
        mealSlotRepositoryProvider.overrideWithValue(mealSlots),
      ],
      initialRoute: '/settings/meals',
    );

    expect(find.text('Meal slots'), findsOneWidget);
    expect(find.byKey(const Key('meal-slot-name-breakfast')), findsOneWidget);
  });
}
