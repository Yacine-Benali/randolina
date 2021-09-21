import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/home_screen.dart';
import 'package:randolina/app/home_admin/admin_home.dart';
import 'package:randolina/app/models/admin.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final Stream userstram;

  @override
  void initState() {
    final AuthUser authUser = context.read<AuthUser>();
    final Database database = context.read<Database>();
    userstram = database.streamDocument(
      path: APIPath.userDocument(authUser.uid),
      builder: (data, documentId) {
        if (data.containsKey('isAdmin')) {
          return Admin.fromMap(data, documentId);
        }
        return User.fromMap2(data, documentId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userstram,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          if (snapshot.data! is Admin) {
            final Admin user = snapshot.data! as Admin;

            return Provider<Admin>.value(
              value: user,
              child: Provider.value(
                value: user,
                child: WillPopScope(
                  onWillPop: () async {
                    final bool a = !await navigatorKey.currentState!.maybePop();
                    return a;
                  },
                  child: Navigator(
                    key: navigatorKey,
                    onGenerateRoute: (routeSettings) {
                      return MaterialPageRoute(
                        builder: (context) => AdminHome(),
                      );
                    },
                  ),
                ),
              ),
            );
          }
          if (snapshot.data! is User) {
            final User user = snapshot.data! as User;
            logger.info('current user ${user.id}');
            return Provider<User>.value(
              value: user,
              child: Provider.value(
                value: user,
                child: WillPopScope(
                  onWillPop: () async {
                    final bool a = !await navigatorKey.currentState!.maybePop();
                    return a;
                  },
                  child: Navigator(
                    key: navigatorKey,
                    onGenerateRoute: (routeSettings) {
                      return MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          // todo @low work on this screen
          return Material(
            child: EmptyContent(
              title: '',
              message: snapshot.error.toString(),
            ),
          );
        }
        return LoadingScreen(showAppBar: false);
      },
    );
  }
}
