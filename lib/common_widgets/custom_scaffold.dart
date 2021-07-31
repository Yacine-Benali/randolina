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
    return Container(
      decoration: backgroundImageDecoration,
      child: Scaffold(
        backgroundColor: backgroundImageDecoration != null
            ? Colors.transparent
            : widget.backgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                flexibleSpace: widget.appBar,
                iconTheme: IconThemeData(
                  color: widget.backgroundImagePath != null
                      ? Colors.white
                      : gradientStart,
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
