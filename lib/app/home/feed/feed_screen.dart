import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/feed_app_bar.dart';
import 'package:randolina/app/home/feed/stories_widget.dart';
import 'package:randolina/constants/app_colors.dart';

enum FilterOptions {
  Report_this_post,
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late bool showPopMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FeedAppBar(),
              StoriesWidget(),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: post.length,
              //   itemBuilder: (context, index) {
              //     return PostWidget();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
