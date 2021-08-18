import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/forgot_password/confirm_phone_number.dart';
import 'package:randolina/app/auth/forgot_password/enter_phone_number.dart';
import 'package:randolina/app/auth/forgot_password/forgot_pass_bloc.dart';
import 'package:randolina/app/auth/forgot_password/new_password.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/utils/logger.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  late final PageController _pageController;
  late ForgotPassBloc bloc;

  late String phoneNumber;
  late String code;
  late String password;

  @override
  void initState() {
    _pageController = PageController();
    bloc = ForgotPassBloc(auth: context.read<Auth>());

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
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.hasClients) {
          if (_pageController.page == 0) {
            return true;
          } else {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
        return false;
      },
      child: Material(
        color: backgroundColor,
        child: SafeArea(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              EnterPhoneNumber(
                onNextPressed: (String value) {
                  try {
                    phoneNumber = value;
                    logger.info(phoneNumber);
                    bloc.verifyPhoneNumber(phoneNumber);
                    swipePage(1);
                  } on Exception catch (e) {
                    logger.severe('Error in verifyPhoneNumber');
                    PlatformExceptionAlertDialog(exception: e).show(context);
                  }
                },
              ),
              ConfirmPhoneNumber(
                onNextPressed: (String value) {
                  code = value;
                  logger.info(code);
                  swipePage(2);
                },
              ),
              NewPassword(
                onNextPressed: (String value) async {
                  try {
                    password = value;
                    logger.info(password);
                    final bool result = await bloc.magic(code, password);
                    if (result == true) Navigator.of(context).pop();
                  } on Exception catch (e) {
                    logger.severe('Error in verifyPhoneNumber');
                    PlatformExceptionAlertDialog(exception: e).show(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
