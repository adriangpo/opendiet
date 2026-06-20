import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/nutrition/vd_reference.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/units/unit_system.dart';
import 'package:opendiet/core/widgets/nutrition_table_br.dart';
import 'package:opendiet/features/foods/domain/food.dart';

import '../../support/test_app.dart';

/// A per-100 g food mirroring the S-07 wireframe; absent fields stay absent.
Food _oats({
  double? servingSizeMetric = 25,
  String? householdMeasure = '2 colheres',
  NutrientBasis basis = NutrientBasis.per100g,
  Nutrients? nutrients,
}) {
  final fixedTime = DateTime.utc(2026);
  return Food(
    id: 'oats',
    name: 'Oats',
    source: FoodSource.custom,
    basis: basis,
    nutrients:
        nutrients ??
        const Nutrients(
          energyKcal: 380,
          carbohydrates: 60,
          totalSugars: 1,
          protein: 13,
          totalFat: 7,
          saturatedFat: 1.2,
          transFat: 0.5,
          dietaryFiber: 10,
          sodiumMilligrams: 5,
        ),
    servingSizeMetric: servingSizeMetric,
    servingUnit: ServingUnit.gram,
    householdMeasure: householdMeasure,
    createdAt: fixedTime,
    updatedAt: fixedTime,
  );
}

/// Pumps [table] inside a scroll view, as the food-detail screen (S-07) does.
Future<void> _pumpTable(WidgetTester tester, NutritionTableBR table) => pumpApp(
  tester,
  Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: table,
    ),
  ),
);

String _cell(WidgetTester tester, String nutrient, String column) =>
    tester.widget<Text>(find.byKey(Key('nutrition-$nutrient-$column'))).data!;

void main() {
  group('NutritionTableBR', () {
    testWidgets('renders the title and the three column headers', (
      tester,
    ) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );

      expect(find.text('Nutrition facts'), findsOneWidget);
      expect(find.text('Per 100 g'), findsOneWidget);
      expect(find.text('Per serving'), findsOneWidget);
      expect(find.text('%DV'), findsOneWidget);
    });

    testWidgets('scales per-serving from per-100 and computes %VD', (
      tester,
    ) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );

      expect(_cell(tester, 'carbohydrates', 'per100'), '60 g');
      // 60 g per 100 g scaled to a 25 g serving = 15 g.
      expect(_cell(tester, 'carbohydrates', 'perServing'), '15 g');
      // 15 g / 300 g reference x 100 = 5%.
      expect(_cell(tester, 'carbohydrates', 'vd'), '5%');
    });

    testWidgets('shows the household measure in the serving column', (
      tester,
    ) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );

      expect(find.textContaining('2 colheres'), findsOneWidget);
    });

    testWidgets('trans fat shows its amount but no %VD', (tester) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );

      expect(_cell(tester, 'transFat', 'per100'), '0.5 g');
      // No region defines a trans-fat reference, so %VD is a dash, not 0%.
      expect(_cell(tester, 'transFat', 'vd'), '-');
    });

    testWidgets('an absent nutrient reads "not informed", never zero', (
      tester,
    ) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );

      // Added sugars was never set on the fixture.
      expect(_cell(tester, 'addedSugars', 'per100'), 'Not informed');
      expect(_cell(tester, 'addedSugars', 'perServing'), 'Not informed');
      expect(_cell(tester, 'addedSugars', 'vd'), '-');
    });

    testWidgets('the %VD reference set follows the selected region', (
      tester,
    ) async {
      // Brazil defines no total-sugars reference; the EU set does.
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );
      expect(_cell(tester, 'totalSugars', 'vd'), '-');

      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.europeanUnion,
          unitSystem: UnitSystem.metric,
        ),
      );
      // 0.25 g per serving / 90 g EU reference rounds to 0%.
      expect(_cell(tester, 'totalSugars', 'vd'), '0%');
    });

    testWidgets('without a serving size the per-serving column is unknown', (
      tester,
    ) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(servingSizeMetric: null, householdMeasure: null),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );

      expect(_cell(tester, 'carbohydrates', 'per100'), '60 g');
      expect(_cell(tester, 'carbohydrates', 'perServing'), 'Not informed');
      expect(_cell(tester, 'carbohydrates', 'vd'), '-');
    });

    testWidgets('a per-serving-basis food back-computes the per-100 column', (
      tester,
    ) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(
            basis: NutrientBasis.perServing,
            nutrients: const Nutrients(carbohydrates: 15),
          ),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.metric,
        ),
      );

      // 15 g per 25 g serving scales up to 60 g per 100 g.
      expect(_cell(tester, 'carbohydrates', 'per100'), '60 g');
      expect(_cell(tester, 'carbohydrates', 'perServing'), '15 g');
    });

    testWidgets('imperial unit system shows the serving size in ounces', (
      tester,
    ) async {
      await _pumpTable(
        tester,
        NutritionTableBR.forFood(
          food: _oats(),
          vdRegion: VdRegion.brazil,
          unitSystem: UnitSystem.imperial,
        ),
      );

      // 25 g is about 0.9 oz; nutrient amounts stay in grams.
      expect(find.textContaining('0.9 oz'), findsOneWidget);
    });
  });
}
