// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the reminders list and handles CRUD + notification scheduling.

@ProviderFor(RemindersController)
final remindersControllerProvider = RemindersControllerProvider._();

/// Exposes the reminders list and handles CRUD + notification scheduling.
final class RemindersControllerProvider
    extends $AsyncNotifierProvider<RemindersController, List<Reminder>> {
  /// Exposes the reminders list and handles CRUD + notification scheduling.
  RemindersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remindersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remindersControllerHash();

  @$internal
  @override
  RemindersController create() => RemindersController();
}

String _$remindersControllerHash() =>
    r'72936cd0a445bbd2cd85c6e6083fb2120bde421a';

/// Exposes the reminders list and handles CRUD + notification scheduling.

abstract class _$RemindersController extends $AsyncNotifier<List<Reminder>> {
  FutureOr<List<Reminder>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Reminder>>, List<Reminder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Reminder>>, List<Reminder>>,
              AsyncValue<List<Reminder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
