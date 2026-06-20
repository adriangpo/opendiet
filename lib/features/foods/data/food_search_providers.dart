import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/data/off_providers.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_search_providers.g.dart';

/// Combined search results from local foods and Open Food Facts.
class FoodSearchResult {
  const FoodSearchResult({
    required this.local,
    required this.offProducts,
  });

  final List<Food> local;
  final List<Food> offProducts;

  List<Food> get all => [...offProducts, ...local];
  bool get isEmpty => all.isEmpty;

  FoodSearchResult filterBySource(FoodSourceFilter filter) {
    return switch (filter) {
      FoodSourceFilter.mine => FoodSearchResult(
        local: local,
        offProducts: const [],
      ),
      FoodSourceFilter.savedFromOff => FoodSearchResult(
        local: const [],
        offProducts: offProducts,
      ),
      FoodSourceFilter.all => this,
    };
  }
}

/// Source filter for the foods catalog.
enum FoodSourceFilter { all, mine, savedFromOff }

/// Holds the current search query for the foods catalog.
@Riverpod(keepAlive: true)
class FoodSearchQuery extends _$FoodSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// Holds the current source filter for the foods catalog.
@Riverpod(keepAlive: true)
class FoodSourceFilterNotifier extends _$FoodSourceFilterNotifier {
  @override
  FoodSourceFilter build() => FoodSourceFilter.all;

  void setFilter(FoodSourceFilter filter) => state = filter;
}

/// Searches local foods and Open Food Facts in parallel.
@riverpod
Future<FoodSearchResult> foodSearchResults(Ref ref) async {
  final query = ref.watch(foodSearchQueryProvider);
  if (query.trim().isEmpty) {
    final local = await ref.watch(foodRepositoryProvider).allFoods();
    return FoodSearchResult(local: local, offProducts: const []);
  }

  final local = await ref.watch(foodRepositoryProvider).searchFoods(query);
  final offResult = await ref
      .watch(offRepositoryProvider)
      .searchProducts(query);

  return FoodSearchResult(
    local: local,
    offProducts: offResult.products,
  );
}
