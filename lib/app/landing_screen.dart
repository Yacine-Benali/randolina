import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/role_selector/role_selector_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/services/auth.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    SizeConfig.init(context);
    return StreamBuilder<AuthUser?>(
      stream: auth.onAuthStateChanged,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.active) {
          final AuthUser? user = authSnapshot.data;
          if (user == null) {
            // return RoleSelectorScreen2(
            //   role: Role.A,
            // );
            //  return  SignInScreen();
            return RoleSelectorScreen();
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
