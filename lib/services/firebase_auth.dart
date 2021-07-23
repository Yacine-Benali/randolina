import 'package:firebase_auth/firebase_auth.dart';
import 'package:randolina/services/auth.dart';

class FirebaseAuthService implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthUser? _userFromFirebase(User? user) {
    if (user == null || user.email == null) {
      return null;
    }
    return AuthUser(
      uid: user.uid,
      email: user.email!,
    );
  }

  @override
  Stream<AuthUser?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future verifyPhoneNumber(
    String mobile,
    Function(FirebaseAuthException) onVerificationFailed,
    Function(String, int?) onCodeSent,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobile,
      //
      timeout: const Duration(seconds: 60),
      //
      verificationCompleted: (AuthCredential authCredential) =>
          _onVerificationCompleted(authCredential),
      //
      verificationFailed: onVerificationFailed,
      //
      codeSent: (String verificationId, int? forceResendingToken) =>
          onCodeSent(verificationId, forceResendingToken),
      //
      codeAutoRetrievalTimeout: (t) {},
    );
  }

  Future<void> _onVerificationCompleted(AuthCredential authCredential) async {
    await _firebaseAuth.signInWithCredential(authCredential);
  }

  @override
  Future<AuthUser?> currentUser() async {
    final User? user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<AuthUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }
}
