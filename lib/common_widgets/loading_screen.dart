import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/constants/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: Center(
        child: CircularProgressIndicator(
          color: gradientStart,
        ),
      ),
    );
  }
}
