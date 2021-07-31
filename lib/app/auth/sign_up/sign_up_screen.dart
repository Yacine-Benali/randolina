import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/agency/sign_up_agency_screen.dart';
import 'package:randolina/app/auth/sign_up/client/sign_up_client_screen.dart';
import 'package:randolina/app/auth/sign_up/club/sign_up_club_screen.dart';
import 'package:randolina/app/auth/sign_up/role_selector/role_selector_screen.dart';
import 'package:randolina/app/auth/sign_up/store/sign_up_store_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final PageController _pageController;
  Role? selectedRole;
  late Image userBackground;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(
        AssetImage('assets/sign_up_background/user_background.png'), context);
    precacheImage(
        AssetImage('assets/sign_up_background/club_background.png'), context);

    super.didChangeDependencies();
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
          SignUpClientScreen(),
        ],
        if (selectedRole == Role.club) ...[
          SignUpClubScreen(),
        ],
        if (selectedRole == Role.agency) ...[
          SignUpAgencyScreen(),
        ],
        if (selectedRole == Role.store) ...[
          SignUpStoreScreen(),
        ],
      ],
    );
  }
}
