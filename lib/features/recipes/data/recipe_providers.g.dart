// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The recipe repository, backed by the on-device database.

@ProviderFor(recipeRepository)
final recipeRepositoryProvider = RecipeRepositoryProvider._();

/// The recipe repository, backed by the on-device database.

final class RecipeRepositoryProvider
    extends
        $FunctionalProvider<
          RecipeRepository,
          RecipeRepository,
          RecipeRepository
        >
    with $Provider<RecipeRepository> {
  /// The recipe repository, backed by the on-device database.
  RecipeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecipeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeRepository create(Ref ref) {
    return recipeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeRepository>(value),
    );
  }
}

String _$recipeRepositoryHash() => r'bf804706006f4fff734de390bf228dcff9c84af0';

/// The list of all saved recipes.

@ProviderFor(recipeList)
final recipeListProvider = RecipeListProvider._();

/// The list of all saved recipes.

final class RecipeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          FutureOr<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $FutureProvider<List<Recipe>> {
  /// The list of all saved recipes.
  RecipeListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeListHash();

  @$internal
  @override
  $FutureProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipe>> create(Ref ref) {
    return recipeList(ref);
  }
}

String _$recipeListHash() => r'2687106f55807a18b49e1f47e3eff44a89a602de';

/// A recipe by its id, or null when not found.

@ProviderFor(recipeById)
final recipeByIdProvider = RecipeByIdFamily._();

/// A recipe by its id, or null when not found.

final class RecipeByIdProvider
    extends $FunctionalProvider<AsyncValue<Recipe?>, Recipe?, FutureOr<Recipe?>>
    with $FutureModifier<Recipe?>, $FutureProvider<Recipe?> {
  /// A recipe by its id, or null when not found.
  RecipeByIdProvider._({
    required RecipeByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipeByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeByIdHash();

  @override
  String toString() {
    return r'recipeByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Recipe?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Recipe?> create(Ref ref) {
    final argument = this.argument as String;
    return recipeById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeByIdHash() => r'9c50ede9906af498b6cd42fbe4651ab5e87de8e1';

/// A recipe by its id, or null when not found.

final class RecipeByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Recipe?>, String> {
  RecipeByIdFamily._()
    : super(
        retry: null,
        name: r'recipeByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A recipe by its id, or null when not found.

  RecipeByIdProvider call(String id) =>
      RecipeByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'recipeByIdProvider';
}
