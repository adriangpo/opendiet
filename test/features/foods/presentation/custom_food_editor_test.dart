import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
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
    expect(find.byIcon(Icons.functions), findsOneWidget); // "calculated"
  });

  testWidgets('editing energy switches it to manual and stops auto-calc', (
    tester,
  ) async {
    await _pumpEditor(tester, FakeFoodRepository());

    await tester.enterText(find.byKey(const Key('field-carbohydrates')), '10');
    await tester.pump();

    await tester.enterText(find.byKey(const Key('field-energy')), '999');
    await tester.pump();

    expect(find.byIcon(Icons.lock_outline), findsOneWidget); // "manual"
    expect(find.byIcon(Icons.functions), findsNothing);

    // Changing a macro no longer moves the user-owned energy value.
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

    expect(_energyText(tester), '80'); // 20 g carbs * 4
    expect(find.byIcon(Icons.functions), findsOneWidget);
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
}
