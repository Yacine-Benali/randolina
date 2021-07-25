import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/landing_screen.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<Auth>(
      create: (context) => FirebaseAuthService(),
      child: MaterialApp(
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Color.fromRGBO(41, 67, 107, 1),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          appBarTheme: AppBarTheme(),
        ),
        debugShowCheckedModeBanner: false,
        title: 'randolina',
        home: const LandingScreen(),
      ),
    );
  }
}
