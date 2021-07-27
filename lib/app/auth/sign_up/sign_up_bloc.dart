import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/services/auth.dart';

class SignUpBloc {
  SignUpBloc({
    required this.auth,
    required this.box,
  });
  final Auth auth;
  final Box<Map<String, dynamic>> box;
  String? verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      /// fires automatically if the app reads the sms
      verificationCompleted: (PhoneAuthCredential credential) {
        logger.warning('****automatic verification');
      },

      /// firebase auth returned an error
      onVerificationFailed: (FirebaseAuthException e) {
        throw e;
      },

      /// When Firebase sends an SMS code to the device, this handler is triggered
      /// Once triggered, it would be a good time to update your application UI
      /// to prompt the user to enter the SMS code they're expecting/
      onCodeSent: (String verificationId2, int? resendToken) {
        verificationId = verificationId2;
        logger.info('****codeSent: $verificationId');
        // Sign the user in (or link) with the credential
        // await auth.signInWithCredential(credential);
      },
    );
  }

  Future<bool> magic(
    Map<String, dynamic> userInfo,
    String phoneCode,
  ) async {
    // throws if the code has not been sent yet
    if (verificationId == null) {
      throw FirebaseAuthException(
        code: 'CODE_NOT_SENT_YET',
        message: 'verification code has not been sent yet',
      );
    }
    final String email =
        '${userInfo['username'] as String}@randolina-10bf4.firebaseapp.com';

    // sign in the user with email/password
    final bool isAlreadySignedIn = auth.currentUser() != null || false;
    if (!isAlreadySignedIn) {
      await auth.createUserWithEmailAndPassword(
        email,
        userInfo['password'] as String,
      );
    }
    // verify phone number and link phone to the user
    await auth.linkUserPhoneNumber(phoneCode, verificationId!);
    await box.put(loclUserInfoKey, userInfo);
    AuthUser? user = auth.currentUser();
    return user == null ? false : true;
  }
}
