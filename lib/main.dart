import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/landing_screen.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<Auth>(
      create: (context) => FirebaseAuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'randolina',
        home: const LandingScreen(),
      ),
    );
  }
}
