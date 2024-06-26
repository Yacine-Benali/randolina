import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home_admin/approved/approved_screen.dart';
import 'package:randolina/app/home_admin/moderators/moderators_screen.dart';
import 'package:randolina/app/home_admin/reported_posts/reported_posts_screen.dart';
import 'package:randolina/app/home_admin/sites/sites_screen.dart';
import 'package:randolina/app/home_admin/subscribers/sub_screen.dart';
import 'package:randolina/app/models/admin.dart';
import 'package:randolina/common_widgets/fab_bottom_app_bar.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late final Admin admin;
  int index = 4;
  late List<Widget> screens;

  @override
  void initState() {
    admin = context.read<Admin>();
    super.initState();
    screens = [
      ModeratorsScreen(),
      SitesScreen(),
      ReportedPostsScreen(),
      ApprovedScreen(),
      SubScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return WillPopScope(
      onWillPop: () async {
        if (index == 0) {
          return true;
        } else {
          setState(() {
            index = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        body: IndexedStack(index: index, children: screens),
        bottomNavigationBar: FABBottomAppBar( 
          buildCenterSpace: false,
          height: 55,
          iconSize: 32,
          centerItemText: '',
          color: Colors.grey,
          selectedColor: darkBlue,
          notchedShape: CircularNotchedRectangle(),
          selectedIndex: index,
          onTabSelected: (int index) {
            setState(() => this.index = index);
          },
          items: [
            // TODO @high fix icons
            FABBottomAppBarItem(iconData: Icons.people, notification: 0),
            FABBottomAppBarItem(iconData: Icons.gps_fixed, notification: 0),
            FABBottomAppBarItem(iconData: Icons.report, notification: 0),
            FABBottomAppBarItem(iconData: Icons.report, notification: 0),
            FABBottomAppBarItem(
                iconData: Icons.account_circle_outlined, notification: 0),
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
