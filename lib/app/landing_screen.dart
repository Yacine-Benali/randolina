import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_in/sign_in_screen.dart';
import 'package:randolina/app/base_screen.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/services/auth.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final Auth auth = context.read<Auth>();
    GetTimeAgo.setDefaultLocale('fr');

    return StreamBuilder<AuthUser?>(
      stream: auth.onAuthStateChanged,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.active) {
          final AuthUser? user = authSnapshot.data;

          if (user == null) {
            return SignInScreen();
          }
          return Provider.value(
            value: user,
            child: BaseScreen(),
          );
        }
        return LoadingScreen();
      },
    );
  }
}
