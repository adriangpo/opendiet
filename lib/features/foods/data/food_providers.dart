import 'package:opendiet/core/database/database_providers.dart';
import 'package:opendiet/features/foods/data/drift_food_repository.dart';
import 'package:opendiet/features/foods/domain/food_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_providers.g.dart';

/// The food repository, backed by the on-device database.
@Riverpod(keepAlive: true)
FoodRepository foodRepository(Ref ref) =>
    DriftFoodRepository(ref.watch(appDatabaseProvider));
