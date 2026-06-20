import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/widgets/food_list_tile.dart';
import 'package:opendiet/features/foods/domain/food.dart';

import '../../support/test_app.dart';

Future<void> _pumpTile(WidgetTester tester, FoodListTile tile) =>
    pumpApp(tester, Scaffold(body: ListView(children: [tile])));

Food _food({
  String name = 'Oats',
  String? brand = 'Generic',
  FoodSource source = FoodSource.custom,
  NutrientBasis basis = NutrientBasis.per100g,
  Nutrients nutrients = const Nutrients(energyKcal: 180),
  double? servingSizeMetric,
  ServingUnit? servingUnit,
}) {
  final timestamp = DateTime.utc(2026, 6, 19);
  return Food(
    id: 'food-1',
    name: name,
    source: source,
    basis: basis,
    nutrients: nutrients,
    createdAt: timestamp,
    updatedAt: timestamp,
    brand: brand,
    servingSizeMetric: servingSizeMetric,
    servingUnit: servingUnit,
  );
}

void main() {
  testWidgets('shows name, brand and per-100 energy, and fires the action', (
    tester,
  ) async {
    var taps = 0;
    await _pumpTile(
      tester,
      FoodListTile(food: _food(), onAction: () => taps++),
    );

    expect(find.text('Oats'), findsOneWidget);
    expect(find.text('Generic'), findsOneWidget);
    expect(find.text('180 kcal / 100 g'), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    expect(taps, 1);
  });

  testWidgets('a long name is truncated to a single line', (tester) async {
    const longName =
        'Extra special artisanal stone-ground whole-grain rolled oats '
        'with mixed seeds and a label far too long to fit a single line';
    await _pumpTile(
      tester,
      FoodListTile(
        food: _food(name: longName),
        onAction: () {},
      ),
    );

    final title = tester.widget<Text>(find.text(longName));
    expect(title.maxLines, 1);
    expect(title.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a missing brand renders no subtitle but keeps energy', (
    tester,
  ) async {
    await _pumpTile(
      tester,
      FoodListTile(food: _food(brand: null), onAction: () {}),
    );

    expect(find.text('Generic'), findsNothing);
    expect(find.text('180 kcal / 100 g'), findsOneWidget);
    expect(tester.widget<ListTile>(find.byType(ListTile)).subtitle, isNull);
  });

  testWidgets('a per-100 ml food shows the millilitre basis', (tester) async {
    await _pumpTile(
      tester,
      FoodListTile(
        food: _food(basis: NutrientBasis.per100ml),
        onAction: () {},
      ),
    );

    expect(find.text('180 kcal / 100 ml'), findsOneWidget);
  });

  testWidgets('a per-serving food is converted to a per-100 value', (
    tester,
  ) async {
    // 90 kcal per 50 g serving -> 180 kcal / 100 g.
    await _pumpTile(
      tester,
      FoodListTile(
        food: _food(
          basis: NutrientBasis.perServing,
          nutrients: const Nutrients(energyKcal: 90),
          servingSizeMetric: 50,
          servingUnit: ServingUnit.gram,
        ),
        onAction: () {},
      ),
    );

    expect(find.text('180 kcal / 100 g'), findsOneWidget);
  });

  testWidgets('a non-integer energy keeps one decimal place', (tester) async {
    await _pumpTile(
      tester,
      FoodListTile(
        food: _food(nutrients: const Nutrients(energyKcal: 89.4)),
        onAction: () {},
      ),
    );

    expect(find.text('89.4 kcal / 100 g'), findsOneWidget);
  });

  testWidgets('absent energy is shown blank, never zero', (tester) async {
    await _pumpTile(
      tester,
      FoodListTile(
        food: _food(nutrients: Nutrients.empty),
        onAction: () {},
      ),
    );

    expect(find.text('-- kcal / 100 g'), findsOneWidget);
    expect(find.textContaining('0 kcal'), findsNothing);
  });

  testWidgets('the action button exposes its semantic label', (tester) async {
    await _pumpTile(
      tester,
      FoodListTile(
        food: _food(),
        onAction: () {},
        actionIcon: Icons.favorite_border,
        actionLabel: 'Add to diary',
      ),
    );

    expect(
      tester.widget<IconButton>(find.byType(IconButton)).tooltip,
      'Add to diary',
    );
  });
}
