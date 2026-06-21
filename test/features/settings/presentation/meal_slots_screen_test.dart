import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/diary/domain/meal_slot_repository.dart';
import 'package:opendiet/features/settings/presentation/meal_slots_screen.dart';

import '../../../support/fake_meal_slot_repository.dart';
import '../../../support/test_app.dart';

void main() {
  group('MealSlotsScreen (FR-019)', () {
    Future<FakeMealSlotRepository> pumpScreen(
      WidgetTester tester, {
      List<MealSlot> slots = const [
        MealSlot(id: 'breakfast', name: 'Breakfast', position: 0),
        MealSlot(id: 'lunch', name: 'Lunch', position: 1),
        MealSlot(id: 'dinner', name: 'Dinner', position: 2),
      ],
      IdGenerator? idGenerator,
      MealSlotRepository? repository,
    }) async {
      final fakeRepository = repository is FakeMealSlotRepository
          ? repository
          : FakeMealSlotRepository();
      if (repository == null) {
        for (final slot in slots) {
          await fakeRepository.saveMealSlot(slot);
        }
      }
      await pumpApp(
        tester,
        const MealSlotsScreen(),
        overrides: [
          mealSlotRepositoryProvider.overrideWithValue(
            repository ?? fakeRepository,
          ),
          idGeneratorProvider.overrideWithValue(
            idGenerator ?? _SequentialIdGenerator(),
          ),
        ],
      );
      return fakeRepository;
    }

    testWidgets('renders existing slots in position order', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Meal slots'), findsOneWidget);
      expect(find.byKey(const Key('meal-slot-name-breakfast')), findsOneWidget);
      expect(find.byKey(const Key('meal-slot-name-lunch')), findsOneWidget);
      expect(find.byKey(const Key('meal-slot-name-dinner')), findsOneWidget);
      expect(find.text('+ Add slot'), findsOneWidget);
      expect(find.text('Reset to default template'), findsOneWidget);
    });

    testWidgets('shows the empty state when no slots exist', (tester) async {
      await pumpScreen(tester, slots: const []);

      expect(find.text('No meal slots yet.'), findsOneWidget);
      expect(find.text('+ Add slot'), findsOneWidget);
    });

    testWidgets('adds a trimmed slot and persists it on save', (tester) async {
      final repository = await pumpScreen(
        tester,
        idGenerator: _SequentialIdGenerator(prefix: 'new-slot'),
      );

      await tester.tap(find.text('+ Add slot'));
      await tester.pump();
      await tester.enterText(
        find.byKey(const Key('meal-slot-dialog-name')),
        ' Brunch ',
      );
      await tester.tap(find.byKey(const Key('meal-slot-dialog-save')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      final slots = await repository.allMealSlots();
      expect(slots.map((slot) => slot.name), [
        'Breakfast',
        'Lunch',
        'Dinner',
        'Brunch',
      ]);
      expect(slots.last.id, 'new-slot-1');
      expect(slots.last.position, 3);
    });

    testWidgets('rejects empty added slot names', (tester) async {
      final repository = await pumpScreen(tester);

      await tester.tap(find.text('+ Add slot'));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slot-dialog-save')));
      await tester.pump();

      expect(find.text('Enter a slot name'), findsOneWidget);
      expect((await repository.allMealSlots()).length, 3);
    });

    testWidgets('renames a slot and persists it on save', (tester) async {
      final repository = await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key('meal-slot-name-breakfast')),
        'Morning meal',
      );
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      final slots = await repository.allMealSlots();
      expect(slots.first.name, 'Morning meal');
    });

    testWidgets('rejects duplicate slot names before saving', (tester) async {
      final repository = await pumpScreen(tester);

      await tester.enterText(
        find.byKey(const Key('meal-slot-name-breakfast')),
        'Lunch',
      );
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      expect(find.text('Meal slot names must be unique.'), findsOneWidget);
      expect((await repository.allMealSlots()).first.name, 'Breakfast');
    });

    testWidgets('cancelled removal keeps the slot', (tester) async {
      final repository = await pumpScreen(tester);

      await tester.tap(find.byKey(const Key('meal-slot-delete-breakfast')));
      await tester.pump();
      await tester.tap(find.text('Cancel'));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      expect(
        (await repository.allMealSlots()).map((slot) => slot.id),
        contains('breakfast'),
      );
    });

    testWidgets('confirmed removal is persisted on save', (tester) async {
      final repository = await pumpScreen(tester);

      await tester.tap(find.byKey(const Key('meal-slot-delete-breakfast')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slot-remove-confirm')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      expect(
        (await repository.allMealSlots()).map((slot) => slot.id),
        isNot(contains('breakfast')),
      );
    });

    testWidgets('reorders slots and persists contiguous positions', (
      tester,
    ) async {
      final repository = await pumpScreen(tester);

      await tester.tap(find.byKey(const Key('meal-slot-move-up-dinner')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      final slots = await repository.allMealSlots();
      expect(slots.map((slot) => slot.id), ['breakfast', 'dinner', 'lunch']);
      expect(slots.map((slot) => slot.position), [0, 1, 2]);
    });

    testWidgets('reset to default template replaces staged slots', (
      tester,
    ) async {
      final repository = await pumpScreen(
        tester,
        slots: const [MealSlot(id: 'custom', name: 'Custom', position: 0)],
        idGenerator: _SequentialIdGenerator(prefix: 'default'),
      );

      await tester.tap(find.text('Reset to default template'));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      final slots = await repository.allMealSlots();
      expect(slots.map((slot) => slot.name), [
        'Breakfast',
        'Lunch',
        'Dinner',
        'Snacks',
      ]);
      expect(slots.map((slot) => slot.id), [
        'default-1',
        'default-2',
        'default-3',
        'default-4',
      ]);
    });

    testWidgets('surfaces repository failures without dropping the form', (
      tester,
    ) async {
      await pumpScreen(tester, repository: _FailingMealSlotRepository());

      expect(find.text('Could not load meal slots.'), findsOneWidget);
      expect(find.text('+ Add slot'), findsNothing);
    });

    testWidgets('surfaces delete failures without removing persisted data', (
      tester,
    ) async {
      final repository = _DeleteFailingMealSlotRepository();
      await pumpScreen(tester, repository: repository);

      await tester.tap(find.byKey(const Key('meal-slot-delete-breakfast')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slot-remove-confirm')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('meal-slots-save')));
      await tester.pump();

      expect(find.text('Could not save meal slots.'), findsOneWidget);
      expect((await repository.allMealSlots()).single.id, 'breakfast');
    });
  });
}

class _SequentialIdGenerator implements IdGenerator {
  _SequentialIdGenerator({this.prefix = 'slot'});

  final String prefix;
  int _next = 0;

  @override
  String newId() {
    _next += 1;
    return '$prefix-$_next';
  }
}

class _FailingMealSlotRepository implements MealSlotRepository {
  @override
  Future<List<MealSlot>> allMealSlots() async => throw StateError('failed');

  @override
  Future<void> deleteMealSlot(String id) async {}

  @override
  Future<void> saveMealSlot(MealSlot slot) async {}
}

class _DeleteFailingMealSlotRepository implements MealSlotRepository {
  final List<MealSlot> _slots = [
    const MealSlot(id: 'breakfast', name: 'Breakfast', position: 0),
  ];

  @override
  Future<List<MealSlot>> allMealSlots() async => List.of(_slots);

  @override
  Future<void> deleteMealSlot(String id) async =>
      throw StateError('restricted');

  @override
  Future<void> saveMealSlot(MealSlot slot) async {
    final index = _slots.indexWhere((saved) => saved.id == slot.id);
    if (index == -1) {
      _slots.add(slot);
    } else {
      _slots[index] = slot;
    }
  }
}
