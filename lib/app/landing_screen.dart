import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/role_selector/role_selector_screen.dart';
import 'package:randolina/services/auth.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final Auth auth = context.read<Auth>();
    auth.init();

    return StreamBuilder<AuthUser?>(
        stream: auth.onAuthStateChanged,
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.active) {
            final AuthUser? user = authSnapshot.data;
            if (user != null && user.isPhoneNumberVerified == true) {
              return Scaffold(
                appBar: AppBar(),
                body: Container(
                  color: Colors.red,
                  child: ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                    },
                    child: Text('signout'),
                  ),
                ),
              );
            } else {
              return Navigator(
                key: navigatorKey,
                initialRoute: '/',
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => RoleSelectorScreen(),
                  );
                },
              );
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          );
        });
  }
}
