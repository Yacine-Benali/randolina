import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_header.dart';

class ClubProfileScreen extends StatefulWidget {
  ClubProfileScreen({Key? key}) : super(key: key);

  @override
  _ClubProfileScreenState createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            ClubHeader(),
          ],
        ),
      ),
    );
  }
}
