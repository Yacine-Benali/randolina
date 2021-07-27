import 'package:randolina/services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});

  final Auth auth;

  Future<void> signIn(String username, String password) async {
    final String email = '$username@randolina-10bf4.firebaseapp.com';
    await auth.signInWithEmailAndPassword(email, password);
  }
}
