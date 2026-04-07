enum AuthStatus {
  /// No Firebase Auth session.
  unauthenticated,

  /// Signed in anonymously (auto, after onboarding).
  anonymous,

  /// Signed in with Google or Apple (account linked).
  authenticated,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.uid,
    this.displayName,
    this.email,
    this.isLoading = false,
    this.error,
  });

  final AuthStatus status;
  final String? uid;
  final String? displayName;
  final String? email;
  final bool isLoading;
  final String? error;

  bool get isSignedIn =>
      status == AuthStatus.anonymous || status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    String? uid,
    String? displayName,
    String? email,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
