import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/client/sign_up_screen_client.dart';
import 'package:randolina/app/auth/sign_up/role_selector/role_selector_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/strings.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final PageController _pageController;
  Role? selectedRole;

  @override
  void initState() {
    _pageController = PageController();
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
    SizeConfig.init(context);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        RoleSelectorScreen(
          onNextPressed: (var role) {
            setState(() => selectedRole = role);
            swipePage(1);
          },
        ),
        if (selectedRole == Role.client) ...[
          SignUpScreenClient(selectedRole: Role.client),
        ]
      ],
    );
  }
}
