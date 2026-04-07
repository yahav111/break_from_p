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
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      await service.signInAnonymously();
      // State updated via authStateChanges listener.
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  /// Signs in with Google (for new device) or links (if anonymous).
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      if (state.status == AuthStatus.anonymous) {
        await service.linkWithGoogle();
      } else {
        await service.signInWithGoogle();
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Signs in with Apple (for new device) or links (if anonymous).
  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = ref.read(authServiceProvider);
      if (state.status == AuthStatus.anonymous) {
        await service.linkWithApple();
      } else {
        await service.signInWithApple();
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
