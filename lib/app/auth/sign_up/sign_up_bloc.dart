import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';

class SignUpBloc {
  SignUpBloc({
    required this.auth,
    required this.database,
  });
  final Auth auth;
  final Database database;
  String? verificationId;
  late AuthUser _authUser;

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
    String username,
    String password,
    String phoneCode,
  ) async {
    // throws if the code has not been sent yet
    if (verificationId == null) {
      throw FirebaseAuthException(
        code: 'CODE_NOT_SENT_YET',
        message: 'verification code has not been sent yet',
      );
    }
    final String email = '$username@randolina-10bf4.firebaseapp.com';

    // sign in the user with email/password
    final AuthUser? authUser = auth.currentUser();
    if (authUser != null) {
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
  }

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    // upload file
    final Client client = Client(
      id: _authUser.uid,
      type: 0,
      username: userInfo['username'] as String,
      name: userInfo['username'] as String,
      profilePicture: 'profilePicture',
      bio: 'bio',
      posts: 0,
      followers: 0,
      following: 0,
      wilaya: 0,
      phoneNumber: '0',
      activity: '0',
      dateOfBirth: Timestamp.now(),
      address: 'address',
      physicalCondition: 'physicalCondition',
    );
    //
    await database.setData(
      path: APIPath.userDocument(_authUser.uid),
      data: client.toMap(),
      merge: false,
    );
  }
}
