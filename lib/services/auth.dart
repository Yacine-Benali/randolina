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
  AuthUser? currentUser();
  Stream<AuthUser?> get onAuthStateChanged;
  Future<AuthUser?> signUpWithEmailAndPassword(
    String email,
    String password,
  );

  Future<AuthUser?> signInWithEmailAndPassword(String email, String password);
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(String, int?) onCodeSent,
  });
  Future<void> linkUserPhoneNumber(
    String smsCode,
    String verificationId,
  );

  Future<void> signOut();
  Future<void> reesetPassword(String newpassword);
  Future<void> signUpWithPhoneNumber(String smsCode, String verificationId);
}
