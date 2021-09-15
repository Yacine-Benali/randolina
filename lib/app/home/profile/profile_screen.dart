import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_screen.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  late User otherUser;
  late final ProfileBloc bloc;
  late final bool showProfileAsOther;
  Future<bool>? isFollowingOther;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    currentUser = context.read<User>();
    otherUser = widget.user;
    bloc = ProfileBloc(
      database: context.read<Database>(),
      currentUser: currentUser,
      otherUser: otherUser,
    );
    if (currentUser.id != otherUser.id) {
      showProfileAsOther = true;
      isFollowingOther = bloc.isFollowing();
    } else {
      showProfileAsOther = false;
      isFollowingOther = null;
    }
    _requestPermission();
    super.initState();
  }

  Future<void> _requestPermission() async {
    final bool isGranted = await Permission.storage.status.isGranted;
    if (!isGranted) {
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      final info = statuses[Permission.storage].toString();
      Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_SHORT);
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    rebuildAllChildren(context);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = context.read<User>();
    if (otherUser.id == currentUser.id) {
      otherUser = currentUser;
    }

    return Provider<ProfileBloc>.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: FutureBuilder<bool>(
            future: isFollowingOther,
            builder: (context, snapshot) {
              if (snapshot.hasData || showProfileAsOther == false) {
                late Widget child;
                if (otherUser is Client) {
                  child = ClientProfileScreen(
                    client: otherUser as Client,
                    bloc: bloc,
                    isFollowingOther: snapshot.data,
                    showProfileAsOther: showProfileAsOther,
                  );
                } else if (otherUser is Club) {
                  child = ClubProfileScreen(
                    clubOrAgency: otherUser,
                    bloc: bloc,
                    isFollowingOther: snapshot.data,
                    showProfileAsOther: showProfileAsOther,
                  );
                } else if (otherUser is Agency) {
                  child = ClubProfileScreen(
                    clubOrAgency: otherUser,
                    bloc: bloc,
                    isFollowingOther: snapshot.data,
                    showProfileAsOther: showProfileAsOther,
                  );
                }
                return SafeArea(
                  child: SingleChildScrollView(
                    child: child,
                  ),
                );
              }
              return LoadingScreen(showAppBar: false);
            },
          ),
        ),
      ),
    );
  }
}
