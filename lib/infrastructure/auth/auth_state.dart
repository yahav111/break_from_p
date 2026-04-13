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
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.isEmailLoading = false,
    this.error,
  });

  final AuthStatus status;
  final String? uid;
  final String? displayName;
  final String? email;
  final bool isGoogleLoading;
  final bool isAppleLoading;
  final bool isEmailLoading;
  final String? error;

  bool get isLoading => isGoogleLoading || isAppleLoading || isEmailLoading;

  bool get isSignedIn =>
      status == AuthStatus.anonymous || status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    String? uid,
    String? displayName,
    String? email,
    bool? isGoogleLoading,
    bool? isAppleLoading,
    bool? isEmailLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isAppleLoading: isAppleLoading ?? this.isAppleLoading,
      isEmailLoading: isEmailLoading ?? this.isEmailLoading,
      error: error ?? this.error,
    );
  }
}
