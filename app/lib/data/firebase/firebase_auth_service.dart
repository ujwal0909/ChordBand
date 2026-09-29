import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  try {
    return FirebaseAuth.instance;
  } catch (e) {
    debugPrint('FirebaseAuth instance not available: $e');
    return null;
  }
});

final authServiceProvider = Provider<FirebaseAuthService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthService(auth);
});

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  if (auth == null) {
    return Stream.value(null);
  }
  return auth.authStateChanges();
});

class FirebaseAuthService {
  final FirebaseAuth? _auth;

  FirebaseAuthService(this._auth);

  bool get isAvailable => _auth != null;
  User? get currentUser => _auth?.currentUser;

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    final auth = _auth;
    if (auth == null) return null;
    try {
      final googleProvider = GoogleAuthProvider();
      if (kIsWeb) {
        return await auth.signInWithPopup(googleProvider);
      } else {
        return await auth.signInWithProvider(googleProvider);
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      rethrow;
    }
  }

  /// Sign in anonymously for frictionless local-first usage
  Future<UserCredential?> signInAnonymously() async {
    final auth = _auth;
    if (auth == null) return null;
    try {
      return await auth.signInAnonymously();
    } catch (e) {
      debugPrint('Anonymous sign-in error: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    final auth = _auth;
    if (auth == null) return null;
    try {
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } catch (e) {
      debugPrint('Email sign-in error: $e');
      rethrow;
    }
  }

  /// Create an account with email and password
  Future<UserCredential?> registerWithEmail(
      String email, String password) async {
    final auth = _auth;
    if (auth == null) return null;
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    final auth = _auth;
    if (auth == null) return;
    try {
      await auth.signOut();
    } catch (e) {
      debugPrint('Sign-out error: $e');
      rethrow;
    }
  }

  /// Self-service account deletion (Google Play policy compliance)
  Future<void> deleteAccount() async {
    final auth = _auth;
    if (auth == null || auth.currentUser == null) return;
    try {
      await auth.currentUser!.delete();
    } catch (e) {
      debugPrint('Account deletion error: $e');
      rethrow;
    }
  }
}
