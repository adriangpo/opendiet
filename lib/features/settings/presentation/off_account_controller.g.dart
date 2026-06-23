// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'off_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the signed-in Open Food Facts account state (FR-012).

@ProviderFor(OffAccountController)
final offAccountControllerProvider = OffAccountControllerProvider._();

/// Exposes the signed-in Open Food Facts account state (FR-012).
final class OffAccountControllerProvider
    extends $AsyncNotifierProvider<OffAccountController, OffAccount?> {
  /// Exposes the signed-in Open Food Facts account state (FR-012).
  OffAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offAccountControllerHash();

  @$internal
  @override
  OffAccountController create() => OffAccountController();
}

String _$offAccountControllerHash() =>
    r'12416ca05401a4cfb98a0d5278f4763365bdc328';

/// Exposes the signed-in Open Food Facts account state (FR-012).

abstract class _$OffAccountController extends $AsyncNotifier<OffAccount?> {
  FutureOr<OffAccount?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<OffAccount?>, OffAccount?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OffAccount?>, OffAccount?>,
              AsyncValue<OffAccount?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
