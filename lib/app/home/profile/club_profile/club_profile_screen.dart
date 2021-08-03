import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_header.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/user.dart';

class ClubProfileScreen extends StatelessWidget {
  const ClubProfileScreen({
    Key? key,
    required this.clubOrAgency,
    required this.showProfileAsOther,
    required this.isFollowingOther,
    required this.bloc,
  }) : super(key: key);

  // this is either a club or an agency
  final User clubOrAgency;
  final ProfileBloc bloc;
  final bool showProfileAsOther;
  final bool isFollowingOther;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            ClubHeader(
              clubOrAgency: clubOrAgency,
              showProfileAsOther: showProfileAsOther,
              onEditPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClubProfileEditScreen(
                      clubOrAgency: clubOrAgency,
                      bloc: bloc,
                    ),
                  ),
                );
              },
              isFollowingOther: null,
            ),
          ],
        ),
      ),
    );
  }
}
