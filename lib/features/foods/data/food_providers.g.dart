// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The food repository, backed by the on-device database.

@ProviderFor(foodRepository)
final foodRepositoryProvider = FoodRepositoryProvider._();

/// The food repository, backed by the on-device database.

final class FoodRepositoryProvider
    extends $FunctionalProvider<FoodRepository, FoodRepository, FoodRepository>
    with $Provider<FoodRepository> {
  /// The food repository, backed by the on-device database.
  FoodRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodRepositoryHash();

  @$internal
  @override
  $ProviderElement<FoodRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FoodRepository create(Ref ref) {
    return foodRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodRepository>(value),
    );
  }
}

String _$foodRepositoryHash() => r'125392e867c4c28be985a3e4a4cb7893b7a3a683';

/// The list of all saved foods, kept in sync via the repository stream.

@ProviderFor(foodList)
final foodListProvider = FoodListProvider._();

/// The list of all saved foods, kept in sync via the repository stream.

final class FoodListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          Stream<List<Food>>
        >
    with $FutureModifier<List<Food>>, $StreamProvider<List<Food>> {
  /// The list of all saved foods, kept in sync via the repository stream.
  FoodListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodListHash();

  @$internal
  @override
  $StreamProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Food>> create(Ref ref) {
    return foodList(ref);
  }
}

String _$foodListHash() => r'5c7f5fc9822e4b834a8280682fc928bdef473326';

/// Foods sorted by [Food.lastLoggedAt] descending, limited to 20 (FR-018).

@ProviderFor(recentFoods)
final recentFoodsProvider = RecentFoodsProvider._();

/// Foods sorted by [Food.lastLoggedAt] descending, limited to 20 (FR-018).

final class RecentFoodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          Stream<List<Food>>
        >
    with $FutureModifier<List<Food>>, $StreamProvider<List<Food>> {
  /// Foods sorted by [Food.lastLoggedAt] descending, limited to 20 (FR-018).
  RecentFoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentFoodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentFoodsHash();

  @$internal
  @override
  $StreamProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Food>> create(Ref ref) {
    return recentFoods(ref);
  }
}

String _$recentFoodsHash() => r'e68ccbeffe0a77c000b85b0343463e94eb65bb97';

/// Foods where [Food.isFavorite] is true (FR-018).

@ProviderFor(favoriteFoods)
final favoriteFoodsProvider = FavoriteFoodsProvider._();

/// Foods where [Food.isFavorite] is true (FR-018).

final class FavoriteFoodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          Stream<List<Food>>
        >
    with $FutureModifier<List<Food>>, $StreamProvider<List<Food>> {
  /// Foods where [Food.isFavorite] is true (FR-018).
  FavoriteFoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteFoodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteFoodsHash();

  @$internal
  @override
  $StreamProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Food>> create(Ref ref) {
    return favoriteFoods(ref);
  }
}

String _$favoriteFoodsHash() => r'4f3abb8e0c758c26313730e54c54a7580f2f7fb4';
