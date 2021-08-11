import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/landing_screen.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/services/firebase_auth.dart';
import 'package:randolina/services/firestore_database.dart';
import 'package:randolina/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (true) {
    final String host = Platform.isAndroid ? '192.168.1.3' : 'localhost:8080';
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseStorage.instance.useStorageEmulator(host, 9199);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  initRootLogger();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (context) => FirebaseAuthService()),
        Provider<Database>(create: (context) => FirestoreDatabase()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blueGrey,
          //fontFamily: 'Lato-Black',
          textTheme: TextTheme(
              // bodyText2: TextStyle(
              //   color: Color.fromRGBO(41, 67, 107, 1),
              //   fontWeight: FontWeight.w500,
              //   fontSize: 16,
              // ),
              ),
          appBarTheme: AppBarTheme(),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Randolina',
        home: LandingScreen(),
      ),
    );
  }
}
