import 'package:firebase_auth/firebase_auth.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';

class SignUpBloc {
  SignUpBloc({required this.auth});
  final Auth auth;
  String? verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      /// fires automatically if the app reads the sms
      verificationCompleted: (PhoneAuthCredential credential) {
        print('****automatic verification');
      },

      /// firebase auth returned an error
      onVerificationFailed: (FirebaseAuthException e) {
        logger.severe('****firebase auth error');
        throw e;
      },

      /// When Firebase sends an SMS code to the device, this handler is triggered
      /// Once triggered, it would be a good time to update your application UI
      /// to prompt the user to enter the SMS code they're expecting/
      onCodeSent: (String verificationId2, int? resendToken) {
        verificationId = verificationId2;
        print('****codeSent: $verificationId');
        // Sign the user in (or link) with the credential
        // await auth.signInWithCredential(credential);
      },
    );
  }

  Future<void> magic(Map<String, dynamic> userInfo, String phoneCode) async {
    final String email =
        '${userInfo['username'] as String}@randolina-10bf4.firebaseapp.com';
    // sign in the user with email/password
    final bool isAlreadySignedIn = auth.currentUser() != null || false;

    try {
      if (!isAlreadySignedIn) {
        await auth.createUserWithEmailAndPassword(
          email,
          userInfo['password'] as String,
        );
      }
      // verify phone number and link phone to the user
      await auth.linkUserPhoneNumber(phoneCode, verificationId!);
    } catch (e) {
      rethrow;
    }
  }
}
