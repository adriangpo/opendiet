// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the current search query for the foods catalog.

@ProviderFor(FoodSearchQuery)
final foodSearchQueryProvider = FoodSearchQueryProvider._();

/// Holds the current search query for the foods catalog.
final class FoodSearchQueryProvider
    extends $NotifierProvider<FoodSearchQuery, String> {
  /// Holds the current search query for the foods catalog.
  FoodSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodSearchQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodSearchQueryHash();

  @$internal
  @override
  FoodSearchQuery create() => FoodSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$foodSearchQueryHash() => r'20c31ab0a2c82ae0421012156c1061ca1165d78d';

/// Holds the current search query for the foods catalog.

abstract class _$FoodSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Holds the current source filter for the foods catalog.

@ProviderFor(FoodSourceFilterNotifier)
final foodSourceFilterProvider = FoodSourceFilterNotifierProvider._();

/// Holds the current source filter for the foods catalog.
final class FoodSourceFilterNotifierProvider
    extends $NotifierProvider<FoodSourceFilterNotifier, FoodSourceFilter> {
  /// Holds the current source filter for the foods catalog.
  FoodSourceFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodSourceFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodSourceFilterNotifierHash();

  @$internal
  @override
  FoodSourceFilterNotifier create() => FoodSourceFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodSourceFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodSourceFilter>(value),
    );
  }
}

String _$foodSourceFilterNotifierHash() =>
    r'40cf58e55aad96cc868ebe276020f37d5c08f8a9';

/// Holds the current source filter for the foods catalog.

abstract class _$FoodSourceFilterNotifier extends $Notifier<FoodSourceFilter> {
  FoodSourceFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FoodSourceFilter, FoodSourceFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FoodSourceFilter, FoodSourceFilter>,
              FoodSourceFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Searches local foods and Open Food Facts in parallel.

@ProviderFor(foodSearchResults)
final foodSearchResultsProvider = FoodSearchResultsProvider._();

/// Searches local foods and Open Food Facts in parallel.

final class FoodSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<FoodSearchResult>,
          FoodSearchResult,
          FutureOr<FoodSearchResult>
        >
    with $FutureModifier<FoodSearchResult>, $FutureProvider<FoodSearchResult> {
  /// Searches local foods and Open Food Facts in parallel.
  FoodSearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodSearchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodSearchResultsHash();

  @$internal
  @override
  $FutureProviderElement<FoodSearchResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FoodSearchResult> create(Ref ref) {
    return foodSearchResults(ref);
  }
}

String _$foodSearchResultsHash() => r'2993e2114b3aecc8a02a150ebceac4ae53e42feb';
