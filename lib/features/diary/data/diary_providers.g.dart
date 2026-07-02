// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Incremented after every diary mutation (save/delete) so that
/// [selectedDayEntriesProvider] and other cached providers can re-fetch.

@ProviderFor(DiaryMutation)
final diaryMutationProvider = DiaryMutationProvider._();

/// Incremented after every diary mutation (save/delete) so that
/// [selectedDayEntriesProvider] and other cached providers can re-fetch.
final class DiaryMutationProvider
    extends $NotifierProvider<DiaryMutation, int> {
  /// Incremented after every diary mutation (save/delete) so that
  /// [selectedDayEntriesProvider] and other cached providers can re-fetch.
  DiaryMutationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryMutationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryMutationHash();

  @$internal
  @override
  DiaryMutation create() => DiaryMutation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$diaryMutationHash() => r'4e4790e19583c760b8ad73aa97a821fe17636096';

/// Incremented after every diary mutation (save/delete) so that
/// [selectedDayEntriesProvider] and other cached providers can re-fetch.

abstract class _$DiaryMutation extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The meal-slot repository, backed by the on-device database.

@ProviderFor(mealSlotRepository)
final mealSlotRepositoryProvider = MealSlotRepositoryProvider._();

/// The meal-slot repository, backed by the on-device database.

final class MealSlotRepositoryProvider
    extends
        $FunctionalProvider<
          MealSlotRepository,
          MealSlotRepository,
          MealSlotRepository
        >
    with $Provider<MealSlotRepository> {
  /// The meal-slot repository, backed by the on-device database.
  MealSlotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealSlotRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealSlotRepositoryHash();

  @$internal
  @override
  $ProviderElement<MealSlotRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MealSlotRepository create(Ref ref) {
    return mealSlotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealSlotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealSlotRepository>(value),
    );
  }
}

String _$mealSlotRepositoryHash() =>
    r'de7e580c8bd1ea2fc30a75c2cc047c079acbc7c1';

/// The diary repository, backed by the on-device database.

@ProviderFor(diaryRepository)
final diaryRepositoryProvider = DiaryRepositoryProvider._();

/// The diary repository, backed by the on-device database.

final class DiaryRepositoryProvider
    extends
        $FunctionalProvider<DiaryRepository, DiaryRepository, DiaryRepository>
    with $Provider<DiaryRepository> {
  /// The diary repository, backed by the on-device database.
  DiaryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiaryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiaryRepository create(Ref ref) {
    return diaryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryRepository>(value),
    );
  }
}

String _$diaryRepositoryHash() => r'6369727dea2695a066b77988574a76c84d231f9d';

/// All meal slots in position order, seeding default slots on first access.

@ProviderFor(mealSlots)
final mealSlotsProvider = MealSlotsProvider._();

/// All meal slots in position order, seeding default slots on first access.

final class MealSlotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MealSlot>>,
          List<MealSlot>,
          FutureOr<List<MealSlot>>
        >
    with $FutureModifier<List<MealSlot>>, $FutureProvider<List<MealSlot>> {
  /// All meal slots in position order, seeding default slots on first access.
  MealSlotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealSlotsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealSlotsHash();

  @$internal
  @override
  $FutureProviderElement<List<MealSlot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MealSlot>> create(Ref ref) {
    return mealSlots(ref);
  }
}

String _$mealSlotsHash() => r'459bbd3fb1a7109f9cc2501628be04709614391b';
