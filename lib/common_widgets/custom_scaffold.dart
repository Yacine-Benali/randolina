import 'package:flutter/material.dart';
import 'package:randolina/constants/app_colors.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    Key? key,
    required this.appBar,
    required this.body,
    this.backgroundColor,
    this.backgroundImagePath,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget appBar;
  final Widget body;
  final String? backgroundImagePath;
  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    Decoration? backgroundImageDecoration;
    if (widget.backgroundImagePath != null) {
      backgroundImageDecoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.backgroundImagePath!),
          fit: BoxFit.cover,
        ),
      );
    }
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: backgroundImageDecoration,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                flexibleSpace: widget.appBar,
                iconTheme: IconThemeData(
                  color: gradientEnd,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => widget.body,
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
