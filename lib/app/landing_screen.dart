import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_in/sign_in_screen.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
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

          if (user == null) {
            return SignInScreen();
          }
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              color: Colors.red,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        auth.signOut();
                      },
                      child: Text('signout'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final box = context.read<Box<Map<String, dynamic>>>();
                        logger.info(box.get(loclUserInfoKey));
                      },
                      child: Text('getInfo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}
