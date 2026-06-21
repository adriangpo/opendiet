import 'dart:developer' as developer;

import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/features/foods/data/off_product_mapper.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;

/// Open Food Facts repository backed by the official Dart SDK (FR-009,
/// FR-010, FR-011).
class OpenFoodFactsRepository implements OffRepository {
  OpenFoodFactsRepository({
    required this._idGenerator,
    required this._clock,
  });

  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Future<OffSearchResult> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 25,
  }) async {
    final safePage = page < 1 ? 1 : page;
    final safePageSize = pageSize < 1 ? 1 : pageSize;
    try {
      final config = off.ProductSearchQueryConfiguration(
        parametersList: [
          off.SearchTerms(terms: [query]),
          off.PageNumber(page: safePage),
          off.PageSize(size: safePageSize),
        ],
        version: off.ProductQueryVersion.v3,
        fields: [
          off.ProductField.BARCODE,
          off.ProductField.NAME,
          off.ProductField.BRANDS,
          off.ProductField.NUTRIMENTS,
          off.ProductField.SERVING_SIZE,
        ],
      );
      final result = await off.OpenFoodAPIClient.searchProducts(
        off.OpenFoodAPIConfiguration.globalUser,
        config,
      );
      final products = result.products ?? [];
      final now = _clock.now();
      return OffSearchResult(
        products: products
            .where((p) => p.barcode != null || p.productName != null)
            .map(
              (p) => OffProductMapper.toFood(
                product: p,
                id: _idGenerator.newId(),
                now: now,
              ),
            )
            .toList(),
        totalCount: result.count ?? products.length,
      );
    } on Object catch (error, stackTrace) {
      developer.log(
        'Open Food Facts search failed',
        name: 'opendiet.off',
        error: error,
        stackTrace: stackTrace,
      );
      return OffSearchResult(products: const [], totalCount: 0);
    }
  }

  @override
  Future<OffBarcodeResult> getProductByBarcode(String barcode) async {
    final config = off.ProductQueryConfiguration(
      barcode,
      version: off.ProductQueryVersion.v3,
      fields: [
        off.ProductField.BARCODE,
        off.ProductField.NAME,
        off.ProductField.BRANDS,
        off.ProductField.NUTRIMENTS,
        off.ProductField.SERVING_SIZE,
      ],
    );
    final result = await off.OpenFoodAPIClient.getProductV3(config);
    final product = result.product;
    if (product == null ||
        (product.barcode == null && product.productName == null)) {
      return const OffBarcodeNotFound();
    }
    final now = _clock.now();
    return OffBarcodeFound(
      OffProductMapper.toFood(
        product: product,
        id: _idGenerator.newId(),
        now: now,
      ),
    );
  }

  @override
  Future<void> saveProduct(Food food) async {
    // Requires authentication -- handled by the OFF account screen (FR-012).
    final user = off.OpenFoodAPIConfiguration.globalUser;
    if (user == null) {
      throw StateError('OFF user not configured for write operations');
    }
    final product = _toOffProduct(food);
    final status = await off.OpenFoodAPIClient.saveProduct(user, product);
    if (status.status != 'status_ok') {
      throw Exception('Failed to save product to OFF: ${status.status}');
    }
  }

  @override
  Future<bool> login(String userId, String password) async {
    final user = off.User(userId: userId, password: password);
    final status = await off.OpenFoodAPIClient.login2(user);
    if (status?.successful == true) {
      off.OpenFoodAPIConfiguration.globalUser = user;
      return true;
    }
    return false;
  }

  off.Product _toOffProduct(Food food) => off.Product(
    barcode: food.barcode,
    productName: food.name,
    brands: food.brand,
  );
}
