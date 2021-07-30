import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/fab_bottom_app_bar.dart';
import 'package:randolina/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _lastSelected = 'TAB: 0';
  int index = 0;
  List<Widget> screens = [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
    Container(color: Colors.pink),
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
            onPressed: () {},
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
          setState(() {
            this.index = index;
          });
        },
        items: [
          FABBottomAppBarItem(iconData: Icons.chat, notification: 5),
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
