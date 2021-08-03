import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_screen.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_screen.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    if (user is Client) {
      return ClientProfileScreen(client: user as Client);
    } else if (user is Club) {
      return ClubProfileScreen(clubOrAgency: user);
    } else if (user is Agency) {
      return ClubProfileScreen(clubOrAgency: user);
    }
    return Container();
  }
}
