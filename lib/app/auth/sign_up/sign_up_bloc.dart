import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:uuid/uuid.dart';

class SignUpBloc {
  SignUpBloc({
    required this.auth,
    required this.database,
  });
  final Auth auth;
  final Database database;
  final Uuid uuid = Uuid();

  String? verificationId;
  late AuthUser _authUser;

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
    String username,
    String password,
    String phoneCode,
  ) async {
    // throws if the code has not been sent yet
    if (verificationId == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'CODE_NOT_SENT_YET',
        message: "le code de vérification n'a pas encore été envoyé",
      );
    }
    final String email = '$username@randolina-10bf4.firebaseapp.com';

    // sign in the user with email/password
    final AuthUser? authUser = auth.currentUser();
    if (authUser == null) {
      await auth.signUpWithEmailAndPassword(
        email,
        password,
      );
    }
    // verify phone number and link phone to the user
    await auth.linkUserPhoneNumber(phoneCode, verificationId!);
    final AuthUser? user = auth.currentUser();
    if (user == null) {
      return false;
    } else {
      _authUser = user;
      return true;
    }
    //! TODO @high if the user quits here he will be logged in without a profile
  }

  Future<String> uploadProfilePicture(File file) async {
    return database.uploadFile(
      path: APIPath.userProfilePicture(_authUser.uid, uuid.v4()),
      filePath: file.path,
    );
  }

  Future<void> saveClientInfo(User user) async {
    await database.setData(
      path: APIPath.userDocument(_authUser.uid),
      data: user.toMap(),
      merge: false,
    );
  }
}
