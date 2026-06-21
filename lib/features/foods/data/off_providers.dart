import 'package:opendiet/core/identifiers/identifier_providers.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/features/foods/data/openfoodfacts_repository.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'off_providers.g.dart';

/// The Open Food Facts repository, backed by the official Dart SDK.
@Riverpod(keepAlive: true)
OffRepository offRepository(Ref ref) => OpenFoodFactsRepository(
  idGenerator: ref.watch(idGeneratorProvider),
  clock: ref.watch(clockProvider),
);
