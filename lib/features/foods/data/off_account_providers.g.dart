// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'off_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Secure credential storage for Open Food Facts account data.

@ProviderFor(offCredentialStore)
final offCredentialStoreProvider = OffCredentialStoreProvider._();

/// Secure credential storage for Open Food Facts account data.

final class OffCredentialStoreProvider
    extends
        $FunctionalProvider<
          OffCredentialStore,
          OffCredentialStore,
          OffCredentialStore
        >
    with $Provider<OffCredentialStore> {
  /// Secure credential storage for Open Food Facts account data.
  OffCredentialStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offCredentialStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offCredentialStoreHash();

  @$internal
  @override
  $ProviderElement<OffCredentialStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OffCredentialStore create(Ref ref) {
    return offCredentialStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OffCredentialStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OffCredentialStore>(value),
    );
  }
}

String _$offCredentialStoreHash() =>
    r'b947139c93e039eb828512028a71378170034441';

/// Open Food Facts account repository (FR-012, NFR-008).

@ProviderFor(offAccountRepository)
final offAccountRepositoryProvider = OffAccountRepositoryProvider._();

/// Open Food Facts account repository (FR-012, NFR-008).

final class OffAccountRepositoryProvider
    extends
        $FunctionalProvider<
          OffAccountRepository,
          OffAccountRepository,
          OffAccountRepository
        >
    with $Provider<OffAccountRepository> {
  /// Open Food Facts account repository (FR-012, NFR-008).
  OffAccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offAccountRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offAccountRepositoryHash();

  @$internal
  @override
  $ProviderElement<OffAccountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OffAccountRepository create(Ref ref) {
    return offAccountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OffAccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OffAccountRepository>(value),
    );
  }
}

String _$offAccountRepositoryHash() =>
    r'cbf4b20a4eda558fc6685ced20b9b9e1a141dfdf';
