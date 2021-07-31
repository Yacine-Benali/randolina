import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/profile_screen.dart';
import 'package:randolina/common_widgets/fab_bottom_app_bar.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 3;
  List<Widget> screens = [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FloatingActionButton(
            onPressed: () {
              context.read<Auth>().signOut();
            },
            backgroundColor: darkBlue,
            tooltip: 'Increment',
            elevation: 2.0,
            child: Icon(Icons.add),
          ),
        ),
      ),
      body: screens[index],
      bottomNavigationBar: FABBottomAppBar(
        height: 55,
        iconSize: 32,
        centerItemText: '',
        color: Colors.grey,
        selectedColor: darkBlue,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: (int index) {
          setState(() => this.index = index);
        },
        items: [
          FABBottomAppBarItem(iconData: Icons.chat, notification: 0),
          FABBottomAppBarItem(iconData: Icons.store, notification: 0),
          FABBottomAppBarItem(iconData: Icons.favorite, notification: 0),
          FABBottomAppBarItem(
              iconData: Icons.account_circle_outlined, notification: 0),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}