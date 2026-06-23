import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/presentation/custom_food_editor.dart';

import '../../../support/fake_food_repository.dart';
import '../../../support/test_app.dart';

String _energyText(WidgetTester tester) => tester
    .widget<TextField>(find.byKey(const Key('field-energy')))
    .controller!
    .text;

Future<void> _pumpEditor(WidgetTester tester, FakeFoodRepository repository) =>
    pumpApp(
      tester,
      const CustomFoodEditor(),
      overrides: [foodRepositoryProvider.overrideWithValue(repository)],
    );

void main() {
  testWidgets('energy auto-calculates from the macros', (tester) async {
    await _pumpEditor(tester, FakeFoodRepository());

    await tester.enterText(find.byKey(const Key('field-carbohydrates')), '10');
    await tester.pump();

    expect(_energyText(tester), '40');
    expect(find.byIcon(Boxicons.bx_calculator), findsOneWidget);
  });

  testWidgets('editing energy switches it to manual and stops auto-calc', (
    tester,
  ) async {
    await _pumpEditor(tester, FakeFoodRepository());

    await tester.enterText(find.byKey(const Key('field-carbohydrates')), '10');
    await tester.pump();

    await tester.enterText(find.byKey(const Key('field-energy')), '999');
    await tester.pump();

    expect(find.byIcon(Boxicons.bx_lock), findsOneWidget);
    expect(find.byIcon(Boxicons.bx_calculator), findsNothing);

    await tester.enterText(find.byKey(const Key('field-carbohydrates')), '20');
    await tester.pump();
    expect(_energyText(tester), '999');
  });

  testWidgets('tapping the manual icon reverts to automatic and recomputes', (
    tester,
  ) async {
    await _pumpEditor(tester, FakeFoodRepository());

    await tester.enterText(find.byKey(const Key('field-carbohydrates')), '20');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('field-energy')), '999');
    await tester.pump();

    final toggle = find.byKey(const Key('energy-mode-toggle'));
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    await tester.tap(toggle);
    await tester.pump();

    expect(_energyText(tester), '80');
    expect(find.byIcon(Boxicons.bx_calculator), findsOneWidget);
  });

  testWidgets('a blank name blocks saving', (tester) async {
    final repository = FakeFoodRepository();
    await _pumpEditor(tester, repository);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Enter a name'), findsOneWidget);
    expect(repository.savedFoods, isEmpty);
  });

  testWidgets('saving persists the food with auto energy', (tester) async {
    final repository = FakeFoodRepository();
    await _pumpEditor(tester, repository);

    await tester.enterText(find.byKey(const Key('field-name')), 'Granola');
    await tester.enterText(find.byKey(const Key('field-carbohydrates')), '10');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = repository.lastSaved!;
    expect(saved.name, 'Granola');
    expect(saved.nutrients.carbohydrates, 10);
    expect(saved.nutrients.energyKcal, 40);
    expect(saved.energyIsManual, isFalse);
  });

  testWidgets('saving keeps a manually-owned energy value', (tester) async {
    final repository = FakeFoodRepository();
    await _pumpEditor(tester, repository);

    await tester.enterText(find.byKey(const Key('field-name')), 'Pastel');
    await tester.enterText(find.byKey(const Key('field-energy')), '250');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = repository.lastSaved!;
    expect(saved.energyIsManual, isTrue);
    expect(saved.nutrients.energyKcal, 250);
  });

  testWidgets('serving size fields shown only when basis is per serving', (
    tester,
  ) async {
    await _pumpEditor(tester, FakeFoodRepository());

    expect(find.text('Serving size'), findsOneWidget);
    expect(find.text('Household measure'), findsOneWidget);

    await tester.tap(find.text('100 g'));
    await tester.pump();

    expect(find.text('Serving size'), findsNothing);
    expect(find.text('Household measure'), findsNothing);

    await tester.tap(find.text('Serving'));
    await tester.pump();

    expect(find.text('Serving size'), findsOneWidget);
    expect(find.text('Household measure'), findsOneWidget);
  });

  testWidgets('required fields (name, energy) show an asterisk', (
    tester,
  ) async {
    await _pumpEditor(tester, FakeFoodRepository());

    final nameField = tester.widget<TextField>(
      find.byKey(const Key('field-name')),
    );
    expect(nameField.decoration?.labelText, endsWith(' *'));

    final energyField = tester.widget<TextField>(
      find.byKey(const Key('field-energy')),
    );
    expect(energyField.decoration?.labelText, endsWith(' *'));
  });

  testWidgets('shows optional nutrients section which is initially collapsed', (
    tester,
  ) async {
    await _pumpEditor(tester, FakeFoodRepository());

    final scrollable = find.byType(Scrollable).last;
    await tester.drag(scrollable, const Offset(0, -600));
    await tester.pump();

    expect(find.text('Optional nutrients'), findsOneWidget);
    expect(
      find.byKey(const Key('optional-nutrients-section')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('field-calcium_mg')), findsNothing);
  });

  testWidgets('keeps micronutrient and sub-type values through save', (
    tester,
  ) async {
    final repository = FakeFoodRepository();
    final food = Food(
      id: 'test-id',
      name: 'Micronutrient Test',
      source: FoodSource.custom,
      basis: NutrientBasis.perServing,
      nutrients: const Nutrients(
        carbohydrates: 10,
        protein: 5,
        totalFat: 3,
        micronutrients: {
          Nutrients.calciumKey: 100.0,
          Nutrients.starchKey: 2.0,
          Nutrients.monounsaturatedKey: 1.0,
        },
      ),
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );

    await pumpApp(
      tester,
      CustomFoodEditor(initialFood: food),
      overrides: [foodRepositoryProvider.overrideWithValue(repository)],
    );

    await tester.tap(find.byKey(const Key('field-name')));
    await tester.enterText(
      find.byKey(const Key('field-name')),
      'Micronutrient Test',
    );
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = repository.lastSaved!;
    expect(saved.nutrients.micronutrients[Nutrients.calciumKey], 100.0);
    expect(saved.nutrients.micronutrients[Nutrients.starchKey], 2.0);
    expect(
      saved.nutrients.micronutrients[Nutrients.monounsaturatedKey],
      1.0,
    );
  });

  testWidgets('barcode field has a scan icon', (tester) async {
    await _pumpEditor(tester, FakeFoodRepository());

    expect(find.byIcon(Boxicons.bx_qr), findsOneWidget);

    final barcodeField = tester.widget<TextField>(
      find.byKey(const Key('field-barcode')),
    );
    final suffixIcon = barcodeField.decoration?.suffixIcon;
    expect(suffixIcon, isA<IconButton>());
  });
}
