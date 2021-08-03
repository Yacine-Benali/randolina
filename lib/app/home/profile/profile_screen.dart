import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_screen.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/services/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User currentUser;
  late final User otherUser;
  late final ProfileBloc bloc;
  late final bool showProfileAsOther;
  Future<bool>? isFollowingOther;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ProfileBloc>.value(
      value: bloc,
      child: Material(
        child: FutureBuilder<bool>(
          future: isFollowingOther,
          builder: (context, snapshot) {
            if (snapshot.hasData || showProfileAsOther == false) {
              late Widget child;
              if (otherUser is Client) {
                child = ClientProfileScreen(
                  client: otherUser as Client,
                  bloc: bloc,
                  isFollowingOther: snapshot.data!,
                  showProfileAsOther: showProfileAsOther,
                );
              } else if (otherUser is Club) {
                child = ClubProfileScreen(
                  clubOrAgency: otherUser,
                  bloc: bloc,
                  isFollowingOther: snapshot.data!,
                  showProfileAsOther: showProfileAsOther,
                );
              } else if (otherUser is Agency) {
                // child = ClubProfileScreen(clubOrAgency: otherUser);
              }
              return SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: child,
                    ),
                    if (showProfileAsOther) ...[
                      Positioned(
                        top: 5,
                        left: 8,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.close,
                            color: Colors.black87,
                            size: 30,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }
            return LoadingScreen();
          },
        ),
      ),
    );
  }
}
