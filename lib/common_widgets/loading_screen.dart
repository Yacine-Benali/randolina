import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/constants/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar ? CustomAppBar() : null,
      body: Center(
        child: CircularProgressIndicator(
          color: gradientStart,
        ),
      ),
    );
  }
}
