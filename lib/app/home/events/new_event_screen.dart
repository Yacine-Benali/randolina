import 'dart:io';

import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/new_event_form1.dart';
import 'package:randolina/constants/app_colors.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    // final Auth auth = context.read<Auth>();
    // final Database database = context.read<Database>();

    super.initState();
  }

  void swipePage(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        title: Text(
          'add an event',
          style: TextStyle(
            color: Color.fromRGBO(34, 50, 99, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          NewEventForm1(
            onPictureChanged: (File value) {
              swipePage(1);
            },
          ),
          Container(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
