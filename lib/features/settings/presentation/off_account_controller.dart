import 'package:opendiet/features/foods/data/off_account_providers.dart';
import 'package:opendiet/features/foods/domain/off_account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'off_account_controller.g.dart';

/// Exposes the signed-in Open Food Facts account state (FR-012).
@riverpod
class OffAccountController extends _$OffAccountController {
  @override
  Future<OffAccount?> build() =>
      ref.watch(offAccountRepositoryProvider).loadAccount();

  /// Signs in and persists credentials through secure storage.
  Future<void> signIn({
    required String userId,
    required String password,
  }) async {
    final account = await ref
        .read(offAccountRepositoryProvider)
        .signIn(userId: userId, password: password);
    state = AsyncData(account);
  }

  /// Signs out and clears persisted credentials.
  Future<void> signOut() async {
    await ref.read(offAccountRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}
