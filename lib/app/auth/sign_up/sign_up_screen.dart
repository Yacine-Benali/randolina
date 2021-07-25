import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/sign_up_role_form.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/constants/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    userInfo = {};
    super.initState();
  }

  @override
  void dispose() {
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          SignUpRoleForm(
            onChanged: (Map<String, dynamic> value) {
              print(value);
            },
            onNextPressed: () {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          Container(
            color: Colors.pink,
          )
        ],
      ),
    );
  }
}
