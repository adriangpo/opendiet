import 'package:opendiet/core/database/database_providers.dart';
import 'package:opendiet/features/recipes/data/drift_recipe_repository.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/recipes/domain/recipe_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe_providers.g.dart';

/// The recipe repository, backed by the on-device database.
@Riverpod(keepAlive: true)
RecipeRepository recipeRepository(Ref ref) =>
    DriftRecipeRepository(ref.watch(appDatabaseProvider));

/// The list of all saved recipes.
@riverpod
Future<List<Recipe>> recipeList(Ref ref) =>
    ref.watch(recipeRepositoryProvider).allRecipes();

/// A recipe by its id, or null when not found.
@riverpod
Future<Recipe?> recipeById(Ref ref, String id) =>
    ref.watch(recipeRepositoryProvider).findRecipe(id);
