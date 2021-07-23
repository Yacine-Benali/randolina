import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  const AuthUser({
    required this.uid,
    required this.email,
  });

  final String uid;
  final String email;
}

abstract class Auth {
  Future<AuthUser?> currentUser();

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    void Function(FirebaseAuthException) onVerificationFailed,
    void Function(String, int?) onCodeSent,
  );

  Future<void> signOut();
  Stream<AuthUser?> get onAuthStateChanged;

  Future<AuthUser?> signInWithEmailAndPassword(String email, String password);
}
