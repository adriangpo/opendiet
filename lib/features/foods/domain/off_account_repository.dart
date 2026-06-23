import 'package:opendiet/features/foods/domain/off_account.dart';

/// Owns Open Food Facts account persistence and sign-in state (FR-012).
abstract interface class OffAccountRepository {
  /// Loads the saved account, if one exists.
  Future<OffAccount?> loadAccount();

  /// Validates and persists an OFF account.
  Future<OffAccount> signIn({
    required String userId,
    required String password,
  });

  /// Removes the saved account and clears the OFF client credentials.
  Future<void> signOut();
}
