import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/quantity.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/core/widgets/quantity_field.dart';

import '../../support/test_app.dart';

void main() {
  late List<Quantity?> emitted;

  setUp(() => emitted = <Quantity?>[]);

  Future<void> pumpField(
    WidgetTester tester, {
    UnitSystem unitSystem = UnitSystem.metric,
    bool hasServingSize = false,
    Quantity? initialValue,
  }) => pumpApp(
    tester,
    Scaffold(
      body: QuantityField(
        unitSystem: unitSystem,
        hasServingSize: hasServingSize,
        initialValue: initialValue,
        onChanged: emitted.add,
      ),
    ),
  );

  const amountField = Key('quantity-amount');

  String fieldText(WidgetTester tester) =>
      tester.widget<TextField>(find.byKey(amountField)).controller!.text;

  testWidgets('emits a canonical gram quantity for a metric mass amount', (
    tester,
  ) async {
    await pumpField(tester);

    await tester.enterText(find.byKey(amountField), '100');
    await tester.pump();

    expect(
      emitted.last,
      const Quantity(amount: 100, measure: QuantityMeasure.grams),
    );
  });

  testWidgets('hides the servings option when the food has no serving size', (
    tester,
  ) async {
    await pumpField(tester);

    expect(find.text('servings'), findsNothing);
    expect(find.text('g'), findsOneWidget);
    expect(find.text('ml'), findsOneWidget);
  });

  testWidgets('shows servings and defaults to it when a serving size exists', (
    tester,
  ) async {
    await pumpField(tester, hasServingSize: true);

    expect(find.text('servings'), findsOneWidget);

    await tester.enterText(find.byKey(amountField), '2');
    await tester.pump();

    expect(
      emitted.last,
      const Quantity(amount: 2, measure: QuantityMeasure.servings),
    );
  });

  testWidgets('converts an imperial mass amount to canonical grams', (
    tester,
  ) async {
    await pumpField(tester, unitSystem: UnitSystem.imperial);

    expect(find.text('oz'), findsOneWidget);
    expect(find.text('fl oz'), findsOneWidget);

    await tester.enterText(find.byKey(amountField), '1');
    await tester.pump();

    expect(emitted.last!.measure, QuantityMeasure.grams);
    expect(emitted.last!.amount, closeTo(28.349523125, 1e-9));
  });

  testWidgets('converts an imperial volume amount to canonical milliliters', (
    tester,
  ) async {
    await pumpField(tester, unitSystem: UnitSystem.imperial);

    await tester.tap(find.text('fl oz'));
    await tester.pump();

    await tester.enterText(find.byKey(amountField), '1');
    await tester.pump();

    expect(emitted.last!.measure, QuantityMeasure.milliliters);
    expect(emitted.last!.amount, closeTo(29.5735295625, 1e-9));
  });

  testWidgets('re-emits the same number in the newly selected measure', (
    tester,
  ) async {
    await pumpField(tester);

    await tester.enterText(find.byKey(amountField), '100');
    await tester.pump();
    expect(
      emitted.last,
      const Quantity(amount: 100, measure: QuantityMeasure.grams),
    );

    await tester.tap(find.text('ml'));
    await tester.pump();
    expect(
      emitted.last,
      const Quantity(amount: 100, measure: QuantityMeasure.milliliters),
    );
  });

  testWidgets('counts servings without unit conversion under imperial', (
    tester,
  ) async {
    await pumpField(
      tester,
      hasServingSize: true,
      unitSystem: UnitSystem.imperial,
    );

    await tester.enterText(find.byKey(amountField), '2');
    await tester.pump();

    expect(
      emitted.last,
      const Quantity(amount: 2, measure: QuantityMeasure.servings),
    );
  });

  testWidgets('emits null for empty, non-numeric, or negative input', (
    tester,
  ) async {
    await pumpField(tester);

    await tester.enterText(find.byKey(amountField), '100');
    await tester.pump();
    expect(emitted.last, isNotNull);

    await tester.enterText(find.byKey(amountField), '');
    await tester.pump();
    expect(emitted.last, isNull);

    await tester.enterText(find.byKey(amountField), 'abc');
    await tester.pump();
    expect(emitted.last, isNull);

    await tester.enterText(find.byKey(amountField), '-5');
    await tester.pump();
    expect(emitted.last, isNull);
  });

  testWidgets('prefills a metric mass amount as-is', (tester) async {
    await pumpField(tester, initialValue: Quantity.grams(100));

    expect(fieldText(tester), '100');
    expect(find.text('g'), findsOneWidget);
  });

  testWidgets('prefills converting a canonical amount to the imperial display '
      'unit', (tester) async {
    await pumpField(
      tester,
      unitSystem: UnitSystem.imperial,
      initialValue: Quantity.grams(28.349523125),
    );

    expect(fieldText(tester), '1');
  });

  testWidgets('prefills a servings amount as a plain count', (tester) async {
    await pumpField(
      tester,
      hasServingSize: true,
      initialValue: Quantity.servings(3),
    );

    expect(fieldText(tester), '3');
    expect(find.text('servings'), findsOneWidget);
  });

  testWidgets('enters a comma decimal as a valid number', (tester) async {
    await pumpField(tester);

    await tester.enterText(find.byKey(amountField), '100,5');
    await tester.pump();

    expect(
      emitted.last,
      const Quantity(amount: 100.5, measure: QuantityMeasure.grams),
    );
  });

  testWidgets(
    'starts empty for a servings initialValue with hasServingSize false',
    (tester) async {
      await pumpField(
        tester,
        initialValue: Quantity.servings(3),
      );

      expect(fieldText(tester), '');
      expect(find.text('servings'), findsNothing);
      expect(find.text('g'), findsOneWidget);
    },
  );
}
