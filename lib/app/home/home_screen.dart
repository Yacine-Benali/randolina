import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/create/camera_screen.dart';
import 'package:randolina/app/home/events/events_screen.dart';
import 'package:randolina/app/home/feed/feed_screen.dart';
import 'package:randolina/app/home/profile/profile_screen.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/fab_bottom_app_bar.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final User user;
  int index = 0;
  late List<Widget> screens;
  List<CameraDescription>? cameras;
  CameraConsumer cameraConsumer = CameraConsumer.post;

  @override
  void initState() {
    user = context.read<User>();
    super.initState();
    screens = [];
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (_) {}
  }

  Widget getScreen(int index) {
    switch (index) {
      case 0:
        return FeedScreen();

      case 1:
        return Container(color: backgroundColor);

      case 2:
        return EventsScreen();

      case 3:
        return ProfileScreen(user: user);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton(
          onPressed: () {
            if (cameras != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CameraScreen(
                    cameras: cameras!,
                    backToHomeScreen: () => Navigator.of(context).pop(),
                    cameraConsumer: cameraConsumer,
                  ),
                ),
              );
            }
          },
          backgroundColor: darkBlue,
          elevation: 2.0,
          child: Icon(Icons.add),
        ),
      ),
      body: getScreen(index),
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
          FABBottomAppBarItem(iconData: Icons.home, notification: 0),
          FABBottomAppBarItem(iconData: Icons.store, notification: 0),
          FABBottomAppBarItem(iconData: Icons.calendar_today, notification: 0),
          FABBottomAppBarItem(
              iconData: Icons.account_circle_outlined, notification: 0),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}
