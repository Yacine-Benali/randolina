import 'package:flutter/material.dart';
import 'package:randolina/constants/app_colors.dart';

class ProfilePostsTabBar extends StatefulWidget {
  const ProfilePostsTabBar({
    Key? key,
    required this.onTabChanged,
  }) : super(key: key);
  final ValueChanged<int> onTabChanged;

  @override
  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePostsTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextStyle textstyle = TextStyle(
    color: darkBlue,
    fontWeight: FontWeight.w800,
  );

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      widget.onTabChanged(_tabController.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PreferredSize(
        preferredSize: Size.fromHeight(35.0), // here the desired height
        child: Material(
          color: Colors.blueGrey[100],
          elevation: 1,
          borderRadius: BorderRadius.circular(50),
          child: TabBar(
            controller: _tabController,
            labelStyle: textstyle,
            labelPadding: EdgeInsets.zero,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            indicatorColor: Colors.blue[900],
            labelColor: darkBlue,
            tabs: [
              Tab(text: 'Tous'),
              Tab(text: 'Photos'),
              Tab(text: 'Videos'),
            ],
          ),
        ),
      ),
    );
  }
}
