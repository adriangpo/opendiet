import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';

/// An in-memory [OffRepository] for tests that never hits the live API.
class FakeOffRepository implements OffRepository {
  final List<Food> _products = [];
  bool isAuthenticated = false;

  void addProduct(Food food) => _products.add(food);

  @override
  Future<OffSearchResult> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 25,
  }) async {
    final matched = _products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final safePage = page < 1 ? 1 : page;
    final safePageSize = pageSize < 1 ? 1 : pageSize;
    final start = (safePage - 1) * safePageSize;
    final end = (start + safePageSize).clamp(0, matched.length);
    final paged = start >= matched.length
        ? <Food>[]
        : matched.sublist(start, end);
    return OffSearchResult(products: paged, totalCount: matched.length);
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
    if (!isAuthenticated) {
      throw StateError('OFF account is required to save products');
    }
    _products.add(food);
  }

  @override
  Future<bool> login(String userId, String password) async {
    isAuthenticated = true;
    return true;
  }

  @override
  void restoreCredentials(String userId, String password) {
    isAuthenticated = true;
  }

  @override
  void clearCredentials() {
    isAuthenticated = false;
  }
}
