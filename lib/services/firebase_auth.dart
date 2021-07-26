import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';

class FirebaseAuthService implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserCredential? _emailPasswordCredential;

  final StreamController<AuthUser?> _streamController =
      StreamController<AuthUser?>();

  bool _isPhoneNumberVerified = false;

  AuthUser? _userFromFirebase(User? user) {
    if (user == null || user.email == null) {
      return null;
    }
    return AuthUser(
      uid: user.uid,
      email: user.email!,
      isPhoneNumberVerified: _isPhoneNumberVerified,
    );
  }

  @override
  void init() {
    _firebaseAuth.authStateChanges().listen(
          (event) => _streamController.sink.add(
            _userFromFirebase(event),
          ),
        );
  }

  @override
  Stream<AuthUser?> get onAuthStateChanged {
    return _streamController.stream;
  }

  @override
  Future verifyPhoneNumber({
    required String phoneNumber,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(String, int?) onCodeSent,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      //
      timeout: const Duration(seconds: 60),
      //
      verificationCompleted: verificationCompleted,
      //
      verificationFailed: onVerificationFailed,
      //
      codeSent: (String verificationId, int? forceResendingToken) =>
          onCodeSent(verificationId, forceResendingToken),
      //
      codeAutoRetrievalTimeout: (t) {},
    );
  }

  @override
  AuthUser? currentUser() {
    final User? user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<AuthUser?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    _emailPasswordCredential = authResult;
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> linkUserPhoneNumber(
    String smsCode,
    String verificationId,
  ) async {
    if (_emailPasswordCredential != null) {
      //
      if (_emailPasswordCredential!.user != null) {
        //
        logger.warning('linkUserPhoneNumber called');
        try {
          await _emailPasswordCredential!.user!.linkWithCredential(
            PhoneAuthProvider.credential(
              smsCode: smsCode,
              verificationId: verificationId,
            ),
          );
          _isPhoneNumberVerified = true;
          _streamController.sink.add(currentUser());
        } on Exception catch (e) {
          rethrow;
        }
      } else {
        logger.severe('_emailPasswordCredential.user is NULL ');
      }
    } else {
      logger.severe('_emailPasswordCredential is NULL');
    }
  }
}
