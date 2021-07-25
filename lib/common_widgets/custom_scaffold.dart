import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    Key? key,
    required this.backgroundColor,
    required this.appBar,
    required this.body,
  }) : super(key: key);

  final Color backgroundColor;
  final Widget appBar;
  final Widget body;
  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: widget.appBar,
            ),
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                (context, index) => widget.body,
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
