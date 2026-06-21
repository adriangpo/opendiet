import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/data/off_product_mapper.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;

void main() {
  group('OffProductMapper', () {
    final fixedTime = DateTime(2026, 6, 20);
    const id = 'test-id-1';

    off.Nutriments nutriments0({
      double? energy,
      double? proteins,
      double? sugars,
      double? addedSugars,
    }) => off.Nutriments.fromJson({
      'energy-kcal_100g': ?energy,
      'proteins_100g': ?proteins,
      'sugars_100g': ?sugars,
      'added-sugars_100g': ?addedSugars,
    });

    off.Product product0({
      String? barcode = '123456',
      String? productName = 'Test Product',
      String? brands,
      off.Nutriments? nutriments,
      String? nutrimentDataPer,
      String? quantity,
      String? servingSize,
      double? servingQuantity,
    }) => off.Product(
      barcode: barcode,
      productName: productName,
      brands: brands,
      nutriments: nutriments,
      nutrimentDataPer: nutrimentDataPer,
      quantity: quantity,
      servingSize: servingSize,
      servingQuantity: servingQuantity,
    );

    test('maps a full OFF product to Food', () {
      final nutriments = off.Nutriments.fromJson({
        'energy-kcal_100g': 250,
        'carbohydrates_100g': 30,
        'sugars_100g': 10,
        'proteins_100g': 8,
        'fat_100g': 12,
        'saturated-fat_100g': 4,
        'trans-fat_100g': 0.5,
        'fiber_100g': 3,
        'sodium_100g': 0.5,
      });
      final product = product0(
        barcode: '789123',
        productName: 'Arroz Integral',
        brands: 'Tio Joao',
        nutriments: nutriments,
      );

      final food = OffProductMapper.toFood(
        product: product,
        id: id,
        now: fixedTime,
      );

      expect(food.id, id);
      expect(food.name, 'Arroz Integral');
      expect(food.source, FoodSource.openFoodFacts);
      expect(food.barcode, '789123');
      expect(food.brand, 'Tio Joao');
      expect(food.energyIsManual, false);
      expect(food.nutrients.energyKcal, 250);
      expect(food.nutrients.carbohydrates, 30);
      expect(food.nutrients.protein, 8);
      expect(food.nutrients.totalFat, 12);
      expect(food.nutrients.saturatedFat, 4);
      expect(food.nutrients.transFat, 0.5);
      expect(food.nutrients.dietaryFiber, 3);
      expect(food.nutrients.sodiumMilligrams, 500);
    });

    test('handles product with no product name using barcode fallback', () {
      final product = product0(barcode: '999999', productName: null);

      final food = OffProductMapper.toFood(
        product: product,
        id: id,
        now: fixedTime,
      );

      expect(food.name, '999999');
    });

    test('handles product with no nutriments', () {
      final product = product0();

      final food = OffProductMapper.toFood(
        product: product,
        id: id,
        now: fixedTime,
      );

      expect(food.nutrients.energyKcal, isNull);
      expect(food.nutrients.carbohydrates, isNull);
      expect(food.nutrients.protein, isNull);
    });

    test('handles product with partial nutriments', () {
      final nutriments = nutriments0(energy: 100);
      final product = product0(nutriments: nutriments);

      final food = OffProductMapper.toFood(
        product: product,
        id: id,
        now: fixedTime,
      );

      expect(food.nutrients.energyKcal, 100);
      expect(food.nutrients.carbohydrates, isNull);
      expect(food.nutrients.protein, isNull);
    });

    test(
      'maps explicit 100 ml nutrient data as per-100ml without quantity',
      () {
        final product = product0(nutrimentDataPer: '100 ml');

        final food = OffProductMapper.toFood(
          product: product,
          id: id,
          now: fixedTime,
        );

        expect(food.basis, NutrientBasis.per100ml);
      },
    );

    test('does not infer added sugars from total sugars', () {
      final product = product0(nutriments: nutriments0(sugars: 12));

      final food = OffProductMapper.toFood(
        product: product,
        id: id,
        now: fixedTime,
      );

      expect(food.nutrients.totalSugars, 12);
      expect(food.nutrients.addedSugars, isNull);
    });

    test('parses comma decimal serving sizes', () {
      final product = product0(servingSize: '12,5 g');

      final food = OffProductMapper.toFood(
        product: product,
        id: id,
        now: fixedTime,
      );

      expect(food.servingSizeMetric, 12.5);
      expect(food.servingUnit, ServingUnit.gram);
    });
  });
}
