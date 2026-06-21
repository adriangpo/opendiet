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

    Food food0({
      String id = '1',
      String name = 'Test',
      String? barcode = '123',
    }) => Food(
      id: id,
      name: name,
      source: FoodSource.openFoodFacts,
      basis: NutrientBasis.per100g,
      nutrients: const Nutrients(energyKcal: 100),
      barcode: barcode,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    group('searchProducts', () {
      test('stores search results as an unmodifiable list', () {
        final food = food0(name: 'Oats');
        final result = OffSearchResult(products: [food], totalCount: 1);

        expect(
          () => result.products.add(food0(name: 'Banana')),
          throwsA(anything),
        );
      });

      test('returns matching products', () async {
        repository
          ..addProduct(food0(name: 'Oats'))
          ..addProduct(food0(id: '2', name: 'Banana'))
          ..addProduct(food0(id: '3', name: 'Chicken'));

        final result = await repository.searchProducts('Oats');

        expect(result.totalCount, 1);
        expect(result.products.first.name, 'Oats');
      });

      test('returns empty list when no match', () async {
        repository.addProduct(food0(name: 'Oats'));

        final result = await repository.searchProducts('Pizza');

        expect(result.totalCount, 0);
        expect(result.products, isEmpty);
      });

      test('is case-insensitive', () async {
        repository.addProduct(food0(name: 'Greek Yogurt'));

        final result = await repository.searchProducts('greek');

        expect(result.totalCount, 1);
      });

      test('returns all products when no products stored', () async {
        final result = await repository.searchProducts('anything');

        expect(result.totalCount, 0);
      });

      test('applies page and pageSize boundaries', () async {
        repository
          ..addProduct(food0(name: 'Oat A'))
          ..addProduct(food0(id: '2', name: 'Oat B'))
          ..addProduct(food0(id: '3', name: 'Oat C'));

        final firstPage = await repository.searchProducts(
          'Oat',
          pageSize: 2,
        );
        final secondPage = await repository.searchProducts(
          'Oat',
          page: 2,
          pageSize: 2,
        );
        final zeroValues = await repository.searchProducts(
          'Oat',
          page: 0,
          pageSize: 0,
        );
        final emptyPage = await repository.searchProducts(
          'Oat',
          page: 4,
          pageSize: 2,
        );

        expect(firstPage.totalCount, 3);
        expect(firstPage.products.map((food) => food.id), ['1', '2']);
        expect(secondPage.totalCount, 3);
        expect(secondPage.products.map((food) => food.id), ['3']);
        expect(zeroValues.products.map((food) => food.id), ['1']);
        expect(emptyPage.totalCount, 3);
        expect(emptyPage.products, isEmpty);
      });
    });

    group('getProductByBarcode', () {
      test('returns found product for matching barcode', () async {
        repository.addProduct(food0(barcode: '789123'));

        final result = await repository.getProductByBarcode('789123');

        expect(result, isA<OffBarcodeFound>());
        expect((result as OffBarcodeFound).product.barcode, '789123');
      });

      test('returns not-found for unknown barcode', () async {
        repository.addProduct(food0());

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
        final food = food0(id: 'new-id', barcode: '555');
        await repository.saveProduct(food);

        final result = await repository.getProductByBarcode('555');
        expect(result, isA<OffBarcodeFound>());
      });
    });
  });
}
