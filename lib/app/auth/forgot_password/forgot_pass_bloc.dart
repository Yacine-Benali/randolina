import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:randolina/services/auth.dart';
import 'package:randolina/utils/logger.dart';

class ForgotPassBloc {
  ForgotPassBloc({required this.auth});

  final Auth auth;
  String? verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      /// fires automatically if the app reads the sms
      verificationCompleted: (firebase_auth.PhoneAuthCredential credential) {
        logger.warning('****automatic verification');
      },

      /// firebase auth returned an error
      onVerificationFailed: (firebase_auth.FirebaseAuthException e) {
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
    String phoneCode,
    String password,
  ) async {
    // throws if the code has not been sent yet
    if (verificationId == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'CODE_NOT_SENT_YET',
        message: 'verification code has not been sent yet',
      );
    }

    // sign in the user with email/password
    final AuthUser? authUser = auth.currentUser();
    if (authUser == null) {
      await auth.signUpWithPhoneNumber(
        phoneCode,
        verificationId!,
      );
      await auth.reesetPassword(password);
      return true;
    } else {
      return false;
    }
  }
}
