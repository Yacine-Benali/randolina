import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_screen.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_screen.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();

    if (user is Client) {
      return ClientProfileScreen(client: user);
    } else {
      return ClubProfileScreen();
    }
  }
}
