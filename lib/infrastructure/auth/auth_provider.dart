import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_service.dart';
import 'auth_state.dart';

/// Provides the [AuthService] singleton.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Manages Firebase Auth state reactively.
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  StreamSubscription<User?>? _subscription;

  @override
  AuthState build() {
    final service = ref.read(authServiceProvider);

    // Seed with current user state.
    final initial = service.stateFromUser(service.currentUser);

    // Listen to auth state changes.
    _subscription?.cancel();
    _subscription = service.authStateChanges.listen((user) {
      state = service.stateFromUser(user);
    });

    ref.onDispose(() => _subscription?.cancel());

    return initial;
  }

  /// Signs in anonymously. Called silently after onboarding.
  Future<void> signInAnonymously() async {
    state = state.copyWith(isEmailLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      await service.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isEmailLoading: false, error: e.message);
    }
  }

  /// Signs in with Google (for new device) or links (if anonymous).
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isGoogleLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      if (state.status == AuthStatus.anonymous) {
        await service.linkWithGoogle();
      } else {
        await service.signInWithGoogle();
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isGoogleLoading: false, error: _friendlyMessage(e.code));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('cancelled') || msg.contains('canceled') || msg.contains('error 1001')) {
        state = state.copyWith(isGoogleLoading: false);
        return;
      }
      state = state.copyWith(
        isGoogleLoading: false,
        error: 'Google sign-in failed. Please try again.',
      );
    }
  }

  /// Signs in with Apple (for new device) or links (if anonymous).
  Future<void> signInWithApple() async {
    state = state.copyWith(isAppleLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      if (state.status == AuthStatus.anonymous) {
        await service.linkWithApple();
      } else {
        await service.signInWithApple();
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isAppleLoading: false, error: _friendlyMessage(e.code));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('cancelled') || msg.contains('canceled') ||
          msg.contains('error 1001') || msg.contains('error 1000')) {
        state = state.copyWith(isAppleLoading: false);
        return;
      }
      state = state.copyWith(
        isAppleLoading: false,
        error: 'Apple sign-in failed. Please try again.',
      );
    }
  }

  /// Signs up with email (links if anonymous, creates otherwise).
  Future<void> signUpWithEmail(String email, String password) async {
    state = state.copyWith(isEmailLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      if (state.status == AuthStatus.anonymous) {
        await service.linkWithEmail(email, password);
      } else {
        await service.createWithEmail(email, password);
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isEmailLoading: false, error: _friendlyMessage(e.code));
    } catch (e) {
      state = state.copyWith(isEmailLoading: false, error: _friendlyMessage(e.toString()));
    }
  }

  /// Signs in with email and password. For returning users.
  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isEmailLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      await service.signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isEmailLoading: false, error: _friendlyMessage(e.code));
    } catch (e) {
      state = state.copyWith(isEmailLoading: false, error: _friendlyMessage(e.toString()));
    }
  }

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isEmailLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      await service.sendPasswordResetEmail(email);
      state = state.copyWith(isEmailLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isEmailLoading: false, error: _friendlyMessage(e.code));
    } catch (e) {
      state = state.copyWith(isEmailLoading: false, error: _friendlyMessage(e.toString()));
    }
  }

  String _friendlyMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists. Try signing in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 8 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Try again or reset it.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'credential-already-in-use':
        return 'This account is already linked to another user.';
      case 'sign-in-cancelled':
        return '';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Clears the current error state.
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  /// Signs out and resets state.
  Future<void> signOut() async {
    final service = ref.read(authServiceProvider);
    await service.signOut();
  }

  /// Deletes the Firebase Auth account.
  Future<void> deleteAccount() async {
    final service = ref.read(authServiceProvider);
    await service.deleteAccount();
  }
}
