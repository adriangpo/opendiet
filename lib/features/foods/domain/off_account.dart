/// A signed-in Open Food Facts account exposed to UI state.
///
/// Credentials are intentionally not part of this model (NFR-008).
class OffAccount {
  /// Creates an account view for [userId].
  const OffAccount({required this.userId});

  /// The OFF username shown to the user.
  final String userId;

  @override
  String toString() => 'OffAccount(userId: $userId)';
}

/// Raised when OFF does not accept a sign-in attempt.
class OffSignInException implements Exception {
  /// Creates a sign-in failure.
  const OffSignInException();

  @override
  String toString() => 'OffSignInException';
}
