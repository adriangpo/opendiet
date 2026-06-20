import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/widgets/nutrient_totals_bar.dart';

import '../../support/test_app.dart';

/// Finds text inside a single nutrient row, identified by its enum name.
Finder _inRow(String nutrientName, Finder matching) => find.descendant(
  of: find.byKey(Key('totals-row-$nutrientName')),
  matching: matching,
);

void main() {
  testWidgets('shows energy and the three macros with no comparison when no '
      'target is set', (tester) async {
    await pumpApp(
      tester,
      const NutrientTotalsBar(
        totals: Nutrients(
          energyKcal: 1860,
          protein: 96,
          carbohydrates: 210,
          totalFat: 70,
        ),
      ),
    );

    // The four headline nutrients are present with their totals.
    expect(find.text('Energy'), findsOneWidget);
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Carbohydrates'), findsOneWidget);
    expect(find.text('Total fat'), findsOneWidget);
    expect(find.textContaining('1860'), findsOneWidget);
    expect(find.textContaining('96'), findsOneWidget);

    // No target -> no remaining/over comparison anywhere.
    expect(find.textContaining('left'), findsNothing);
    expect(find.textContaining('over'), findsNothing);
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });

  testWidgets('shows remaining amount when under target', (tester) async {
    await pumpApp(
      tester,
      const NutrientTotalsBar(
        totals: Nutrients(energyKcal: 1860),
        target: Nutrients(energyKcal: 2000),
      ),
    );

    expect(_inRow('energy', find.textContaining('140')), findsOneWidget);
    expect(_inRow('energy', find.textContaining('left')), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });

  testWidgets('shows over amount with the error role and an icon when over '
      'target', (tester) async {
    await pumpApp(
      tester,
      const NutrientTotalsBar(
        totals: Nutrients(energyKcal: 2100),
        target: Nutrients(energyKcal: 2000),
      ),
    );

    final overText = _inRow('energy', find.textContaining('100 kcal over'));
    expect(overText, findsOneWidget);

    // Color is never the only signal: the over state pairs text with an icon.
    expect(
      _inRow('energy', find.byIcon(Icons.warning_amber_rounded)),
      findsOneWidget,
    );

    final color = tester.firstWidget<Text>(overText).style?.color;
    final errorColor = Theme.of(tester.element(overText)).colorScheme.error;
    expect(color, errorColor);
  });

  testWidgets('exactly at target shows zero remaining, never over', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const NutrientTotalsBar(
        totals: Nutrients(energyKcal: 2000),
        target: Nutrients(energyKcal: 2000),
      ),
    );

    expect(_inRow('energy', find.textContaining('left')), findsOneWidget);
    expect(find.textContaining('over'), findsNothing);
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });

  testWidgets('compares only the nutrients the target sets a value for', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const NutrientTotalsBar(
        totals: Nutrients(energyKcal: 1860, protein: 96),
        // Target sets energy only; protein/carbs/fat have no target value.
        target: Nutrients(energyKcal: 2000),
      ),
    );

    expect(_inRow('energy', find.textContaining('left')), findsOneWidget);
    expect(_inRow('protein', find.textContaining('left')), findsNothing);
    expect(_inRow('protein', find.textContaining('over')), findsNothing);
  });

  testWidgets('renders empty totals as not-informed when no nutrients set', (
    tester,
  ) async {
    await pumpApp(tester, const NutrientTotalsBar(totals: Nutrients.empty));

    expect(find.text('Energy'), findsOneWidget);
    // Absent nutrients show '--', not '0'.
    expect(find.textContaining('0'), findsNothing);
    expect(find.text('--'), findsWidgets);
    expect(find.textContaining('left'), findsNothing);
    expect(find.textContaining('over'), findsNothing);
  });

  testWidgets('shows warning icons for multiple nutrients over target', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const NutrientTotalsBar(
        totals: Nutrients(energyKcal: 2100, totalFat: 70),
        target: Nutrients(energyKcal: 2000, totalFat: 50),
      ),
    );

    expect(
      _inRow('energy', find.textContaining('100 kcal over')),
      findsOneWidget,
    );
    expect(
      _inRow('energy', find.byIcon(Icons.warning_amber_rounded)),
      findsOneWidget,
    );
    expect(
      _inRow('totalFat', find.textContaining('20 g over')),
      findsOneWidget,
    );
    expect(
      _inRow('totalFat', find.byIcon(Icons.warning_amber_rounded)),
      findsOneWidget,
    );
    // Protein and carbohydrates have no target so no over state.
    expect(
      _inRow('protein', find.byIcon(Icons.warning_amber_rounded)),
      findsNothing,
    );
    expect(
      _inRow('carbohydrates', find.byIcon(Icons.warning_amber_rounded)),
      findsNothing,
    );
  });

  testWidgets('shows over state when target is zero and totals are positive', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const NutrientTotalsBar(
        totals: Nutrients(energyKcal: 100),
        target: Nutrients(energyKcal: 0),
      ),
    );

    expect(
      _inRow('energy', find.textContaining('100 kcal over')),
      findsOneWidget,
    );
    expect(
      _inRow('energy', find.byIcon(Icons.warning_amber_rounded)),
      findsOneWidget,
    );
    // Other nutrients have no target, so only one warning icon appears.
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });
}
