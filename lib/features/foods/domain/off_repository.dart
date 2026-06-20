import 'package:opendiet/features/foods/domain/food.dart';

/// Search result from Open Food Facts (FR-009).
class OffSearchResult {
  const OffSearchResult({
    required this.products,
    required this.totalCount,
  });

  final List<Food> products;
  final int totalCount;
}

/// Lookup result for a barcode scan (FR-010).
sealed class OffBarcodeResult {
  const OffBarcodeResult();
}

class OffBarcodeFound extends OffBarcodeResult {
  const OffBarcodeFound(this.product);

  final Food product;
}

class OffBarcodeNotFound extends OffBarcodeResult {
  const OffBarcodeNotFound();
}

/// External Open Food Facts API operations (FR-009, FR-010, FR-011, FR-012).
///
/// The rest of the app depends on this interface, never on the concrete SDK.
abstract interface class OffRepository {
  /// Searches Open Food Facts for [query].
  Future<OffSearchResult> searchProducts(
    String query, {
    int page,
    int pageSize,
  });

  /// Fetches a product by [barcode].
  Future<OffBarcodeResult> getProductByBarcode(String barcode);

  /// Saves a local [food] as an OFF product.
  Future<void> saveProduct(Food food);

  /// Validates OFF account credentials.
  Future<bool> login(String userId, String password);
}
