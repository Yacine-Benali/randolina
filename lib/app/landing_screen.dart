import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/sign_up_screen.dart';
import 'package:randolina/services/auth.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);

    return StreamBuilder<AuthUser?>(
      stream: auth.onAuthStateChanged,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.active) {
          final AuthUser? user = authSnapshot.data;
          if (user == null) {
            // return SignUpScreen2(
            //   role: Role.A,
            // );
            //  return  SignInScreen();
            return SignUpScreen();
          }
          // return HomeScreen(
          //   apiResponse: snapshot.data[0],
          //   pref: snapshot.data[1],
          // );
          return Container(color: Colors.red);
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
