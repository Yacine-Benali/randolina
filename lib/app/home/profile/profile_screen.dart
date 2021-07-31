import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User user;

  @override
  void initState() {
    user = context.read<User>();
    super.initState();
  }

  Widget buildHeader() {
    return Text(
      '**********',
      style: TextStyle(color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 300,
          backgroundColor: Colors.grey[300],
          flexibleSpace: buildHeader(),
          iconTheme: IconThemeData(
            color: gradientEnd, //change your color here
          ),
        ),
        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildListDelegate(
            [
              Container(
                color: Colors.pink,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
