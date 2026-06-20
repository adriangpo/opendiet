import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';
import '../../../support/fake_off_repository.dart';

void main() {
  group('OffRepository (via FakeOffRepository)', () {
    late FakeOffRepository repository;

    setUp(() {
      repository = FakeOffRepository();
    });

    Food _food({
      String id = '1',
      String name = 'Test',
      String? barcode = '123',
    }) => Food(
      id: id,
      name: name,
      source: FoodSource.openFoodFacts,
      basis: NutrientBasis.per100g,
      nutrients: Nutrients(energyKcal: 100),
      brand: null,
      barcode: barcode,
      servingSizeMetric: null,
      servingUnit: null,
      householdMeasure: null,
      energyIsManual: false,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    group('searchProducts', () {
      test('returns matching products', () async {
        repository.addProduct(_food(id: '1', name: 'Oats'));
        repository.addProduct(_food(id: '2', name: 'Banana'));
        repository.addProduct(_food(id: '3', name: 'Chicken'));

        final result = await repository.searchProducts('Oats');

        expect(result.totalCount, 1);
        expect(result.products.first.name, 'Oats');
      });

      test('returns empty list when no match', () async {
        repository.addProduct(_food(name: 'Oats'));

        final result = await repository.searchProducts('Pizza');

        expect(result.totalCount, 0);
        expect(result.products, isEmpty);
      });

      test('is case-insensitive', () async {
        repository.addProduct(_food(name: 'Greek Yogurt'));

        final result = await repository.searchProducts('greek');

        expect(result.totalCount, 1);
      });

      test('returns all products when no products stored', () async {
        final result = await repository.searchProducts('anything');

        expect(result.totalCount, 0);
      });
    });

    group('getProductByBarcode', () {
      test('returns found product for matching barcode', () async {
        repository.addProduct(_food(id: '1', barcode: '789123'));

        final result = await repository.getProductByBarcode('789123');

        expect(result, isA<OffBarcodeFound>());
        expect((result as OffBarcodeFound).product.barcode, '789123');
      });

      test('returns not-found for unknown barcode', () async {
        repository.addProduct(_food(barcode: '123'));

        final result = await repository.getProductByBarcode('999');

        expect(result, isA<OffBarcodeNotFound>());
      });
    });

    group('login', () {
      test('returns true for valid credentials', () async {
        final success = await repository.login('user', 'pass');
        expect(success, isTrue);
      });
    });

    group('saveProduct', () {
      test('adds product to repository', () async {
        final food = _food(id: 'new-id', barcode: '555');
        await repository.saveProduct(food);

        final result = await repository.getProductByBarcode('555');
        expect(result, isA<OffBarcodeFound>());
      });
    });
  });
}
