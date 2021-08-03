import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_header.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/database.dart';

class ClubProfileScreen extends StatefulWidget {
  ClubProfileScreen({
    Key? key,
    required this.clubOrAgency,
  }) : super(key: key);

  // this is either a club or an agency
  User clubOrAgency;

  @override
  _ClubProfileScreenState createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  late final User currentUser;
  late final bool showProfileAsOther;
  Future<bool>? isFollowingOther;
  late final ProfileBloc bloc;
  @override
  void initState() {
    currentUser = context.read<User>();
    bloc = ProfileBloc(
      database: context.read<Database>(),
      currentUser: currentUser,
      otherUser: widget.clubOrAgency,
    );
    if (currentUser.id != widget.clubOrAgency.id) {
      showProfileAsOther = true;
      // isFollowingOther = bloc.isFollowing();
    } else {
      showProfileAsOther = false;
      isFollowingOther = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            ClubHeader(
              clubOrAgency: widget.clubOrAgency,
              showProfileAsOther: showProfileAsOther,
              onEditPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClubProfileEditScreen(
                      clubOrAgency: widget.clubOrAgency,
                      bloc: bloc,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
