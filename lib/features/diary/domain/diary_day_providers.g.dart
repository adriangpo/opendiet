// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_day_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The calendar day currently shown on the diary (FR-018).
///
/// Initialises to today's date according to the injected clock, so tests stay
/// deterministic. Changes to this provider cause the diary to reload entries.

@ProviderFor(DiaryDay)
final diaryDayProvider = DiaryDayProvider._();

/// The calendar day currently shown on the diary (FR-018).
///
/// Initialises to today's date according to the injected clock, so tests stay
/// deterministic. Changes to this provider cause the diary to reload entries.
final class DiaryDayProvider extends $NotifierProvider<DiaryDay, DateTime> {
  /// The calendar day currently shown on the diary (FR-018).
  ///
  /// Initialises to today's date according to the injected clock, so tests stay
  /// deterministic. Changes to this provider cause the diary to reload entries.
  DiaryDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryDayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryDayHash();

  @$internal
  @override
  DiaryDay create() => DiaryDay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$diaryDayHash() => r'266a2cd093294dfe5afeea4a98a5e18184aefe2a';

/// The calendar day currently shown on the diary (FR-018).
///
/// Initialises to today's date according to the injected clock, so tests stay
/// deterministic. Changes to this provider cause the diary to reload entries.

abstract class _$DiaryDay extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
