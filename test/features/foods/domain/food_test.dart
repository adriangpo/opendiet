import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/domain/food.dart';

Food _sampleFood() => Food(
  id: '0197-food',
  name: 'Greek Yogurt',
  source: FoodSource.custom,
  basis: NutrientBasis.per100g,
  nutrients: const Nutrients(energyKcal: 59, protein: 10),
  servingSizeMetric: 170,
  servingUnit: ServingUnit.gram,
  householdMeasure: '1 pot (170 g)',
  createdAt: DateTime.utc(2026, 6, 19, 8),
  updatedAt: DateTime.utc(2026, 6, 19, 8),
);

void main() {
  group('Food', () {
    test('round-trips through json, preserving nutrients and enums', () {
      final food = _sampleFood();

      final restored = Food.fromJson(food.toJson());

      expect(restored, food);
      expect(restored.source, FoodSource.custom);
      expect(restored.basis, NutrientBasis.per100g);
      expect(restored.nutrients.protein, 10);
    });

    test('optional fields default to absent', () {
      final food = Food(
        id: 'f',
        name: 'Salt',
        source: FoodSource.imported,
        basis: NutrientBasis.per100g,
        nutrients: Nutrients.empty,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );

      expect(food.brand, isNull);
      expect(food.barcode, isNull);
      expect(food.servingSizeMetric, isNull);
      expect(food.householdMeasure, isNull);
      expect(food.lastLoggedAt, isNull);
      expect(food.isFavorite, isFalse);
    });

    test('lastLoggedAt and isFavorite survive json round-trip', () {
      final food = _sampleFood().copyWith(
        lastLoggedAt: DateTime.utc(2026, 6, 20, 10),
        isFavorite: true,
      );

      final restored = Food.fromJson(food.toJson());

      expect(restored.lastLoggedAt, DateTime.utc(2026, 6, 20, 10));
      expect(restored.isFavorite, isTrue);
    });

    test('isFavorite is false by default', () {
      final food = _sampleFood();

      expect(food.isFavorite, isFalse);
    });

    test('lastLoggedAt is null by default', () {
      final food = _sampleFood();

      expect(food.lastLoggedAt, isNull);
    });
  });
}
