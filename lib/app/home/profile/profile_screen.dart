import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_screen.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_screen.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    if (user is Client) {
      Client client = user as Client;
      return Material(child: ClientProfileScreen(client: client));
    } else {
      return ClubProfileScreen();
    }
  }
}
