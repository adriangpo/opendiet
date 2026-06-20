// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'off_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Open Food Facts repository, backed by the official Dart SDK.

@ProviderFor(offRepository)
final offRepositoryProvider = OffRepositoryProvider._();

/// The Open Food Facts repository, backed by the official Dart SDK.

final class OffRepositoryProvider
    extends $FunctionalProvider<OffRepository, OffRepository, OffRepository>
    with $Provider<OffRepository> {
  /// The Open Food Facts repository, backed by the official Dart SDK.
  OffRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offRepositoryHash();

  @$internal
  @override
  $ProviderElement<OffRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OffRepository create(Ref ref) {
    return offRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OffRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OffRepository>(value),
    );
  }
}

String _$offRepositoryHash() => r'640ad2c7a0e790bceb8e8739e70bfafb419f197a';
