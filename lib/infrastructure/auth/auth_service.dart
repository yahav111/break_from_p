import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

import 'auth_state.dart';

/// Wraps Firebase Auth with anonymous, Google, and Apple sign-in.
class AuthService {
  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// Current Firebase user, if any.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Derives [AuthStatus] from the current Firebase user.
  AuthState stateFromUser(User? user) {
    if (user == null) {
      return const AuthState(status: AuthStatus.unauthenticated);
    }
    final isAnonymous = user.isAnonymous;
    return AuthState(
      status: isAnonymous ? AuthStatus.anonymous : AuthStatus.authenticated,
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
    );
  }

  /// Signs in anonymously. Called silently after onboarding.
  Future<UserCredential> signInAnonymously() async {
    return _auth.signInAnonymously();
  }

  /// Signs in with Google. For use on new devices or direct sign-in.
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  /// Links anonymous account to Google. Preserves the UID.
  Future<UserCredential> linkWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No signed-in user to link.');

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return user.linkWithCredential(credential);
  }

  /// Signs in with Apple. For use on new devices or direct sign-in.
  Future<UserCredential> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return _auth.signInWithCredential(oauthCredential);
  }

  /// Links anonymous account to Apple. Preserves the UID.
  Future<UserCredential> linkWithApple() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No signed-in user to link.');

    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return user.linkWithCredential(oauthCredential);
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Deletes the Firebase Auth account.
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
