import 'package:opendiet/features/foods/data/off_credential_store.dart';
import 'package:opendiet/features/foods/domain/off_account.dart';
import 'package:opendiet/features/foods/domain/off_account_repository.dart';
import 'package:opendiet/features/foods/domain/off_repository.dart';

/// Persists OFF account credentials in secure storage and configures writes.
class SecureOffAccountRepository implements OffAccountRepository {
  /// Creates the repository.
  const SecureOffAccountRepository({
    required this.credentials,
    required this.offRepository,
  });

  /// Secure credential storage.
  final OffCredentialStore credentials;

  /// OFF API boundary used for authentication and writes.
  final OffRepository offRepository;

  @override
  Future<OffAccount?> loadAccount() async {
    final saved = await credentials.read();
    if (saved == null) {
      offRepository.clearCredentials();
      return null;
    }
    offRepository.restoreCredentials(saved.userId, saved.password);
    return OffAccount(userId: saved.userId);
  }

  @override
  Future<OffAccount> signIn({
    required String userId,
    required String password,
  }) async {
    final normalizedUserId = userId.trim();
    if (normalizedUserId.isEmpty || password.isEmpty) {
      throw const OffSignInException();
    }

    final accepted = await offRepository.login(normalizedUserId, password);
    if (!accepted) throw const OffSignInException();

    await credentials.write(
      OffStoredCredentials(userId: normalizedUserId, password: password),
    );
    return OffAccount(userId: normalizedUserId);
  }

  @override
  Future<void> signOut() async {
    await credentials.delete();
    offRepository.clearCredentials();
  }
}
