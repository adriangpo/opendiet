import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';

/// An in-memory [OffRepository] for tests that never hits the live API.
class FakeOffRepository implements OffRepository {
  final List<Food> _products = [];

  void addProduct(Food food) => _products.add(food);

  @override
  Future<OffSearchResult> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 25,
  }) async {
    final matched = _products
        .where(
          (p) => p.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return OffSearchResult(products: matched, totalCount: matched.length);
  }

  @override
  Future<OffBarcodeResult> getProductByBarcode(String barcode) async {
    for (final food in _products) {
      if (food.barcode == barcode) return OffBarcodeFound(food);
    }
    return const OffBarcodeNotFound();
  }

  @override
  Future<void> saveProduct(Food food) async {
    _products.add(food);
  }

  @override
  Future<bool> login(String userId, String password) async {
    return true;
  }
}
