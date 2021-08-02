import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/home_screen.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late final Database database;
  late final AuthUser authUser;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    authUser = context.read<AuthUser>();
    database = context.read<Database>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: database.streamDocument(
        path: APIPath.userDocument(authUser.uid),
        builder: (data, documentId) => User.fromMap2(data, documentId),
      ),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          final User user = snapshot.data!;
          return Provider<User>.value(
            value: user,
            child: Provider.value(
              value: user,
              child: Navigator(
                key: navigatorKey,
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => HomeScreen());
                },
              ),
            ),
          );
        }
        return LoadingScreen();
      },
    );
  }
}
