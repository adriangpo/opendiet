import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// OFF credentials stored at rest.
class OffStoredCredentials {
  /// Creates stored credentials.
  const OffStoredCredentials({
    required this.userId,
    required this.password,
  });

  /// The OFF username.
  final String userId;

  /// The OFF password.
  final String password;
}

/// Storage boundary for OFF credentials (NFR-008).
abstract interface class OffCredentialStore {
  /// Reads saved credentials, or null when none are stored.
  Future<OffStoredCredentials?> read();

  /// Writes [credentials] to secure storage.
  Future<void> write(OffStoredCredentials credentials);

  /// Removes saved credentials.
  Future<void> delete();
}

/// Secure-storage-backed OFF credential store.
class FlutterSecureOffCredentialStore implements OffCredentialStore {
  /// Creates the store.
  const FlutterSecureOffCredentialStore([
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  ]) : _storage = storage;

  static const String _userIdKey = 'open_food_facts_user_id';
  static const String _passwordKey = 'open_food_facts_password';

  final FlutterSecureStorage _storage;

  @override
  Future<OffStoredCredentials?> read() async {
    final userId = await _storage.read(key: _userIdKey);
    final password = await _storage.read(key: _passwordKey);
    if (userId == null ||
        userId.isEmpty ||
        password == null ||
        password.isEmpty) {
      return null;
    }
    return OffStoredCredentials(userId: userId, password: password);
  }

  @override
  Future<void> write(OffStoredCredentials credentials) async {
    await _storage.write(key: _userIdKey, value: credentials.userId);
    await _storage.write(key: _passwordKey, value: credentials.password);
  }

  @override
  Future<void> delete() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _passwordKey);
  }
}
