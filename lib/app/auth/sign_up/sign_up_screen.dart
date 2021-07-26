import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/sign_up_bloc.dart';
import 'package:randolina/app/auth/sign_up/sign_up_client_form.dart';
import 'package:randolina/app/auth/sign_up/sign_up_phone_confirmation.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/services/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignUpBloc bloc;
  late Map<String, dynamic> userInfo;
  final PageController _pageController = PageController(initialPage: 0);
  Role? selectedRole;

  @override
  void initState() {
    final Auth auth = context.read<Auth>();
    bloc = SignUpBloc(auth: auth);
    userInfo = <String, dynamic>{};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return CustomScaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.screenHeight - 51,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              SignUpClientForm(
                onNextPressed: (Map<String, dynamic> info) async {
                  userInfo.addAll(info);
                  print(userInfo);
                  try {
                    bloc.verifyPhoneNumber(userInfo['phoneNumber'] as String);
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  } catch (e) {
                    logger.severe('Error in verifyPhoneNumber');
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
              ),
              SignUpPhoneConfirmation(
                bloc: bloc,
                onNextPressed: (String code) {
                  if (bloc.verificationId == null) {
                    //todo fix this:
                    logger.info('*pop sms is not sent yet*');
                  } else {
                    try {
                      bloc.magic(userInfo, code);
                    } catch (e) {
                      logger.severe('wrong sms bitch');
                      logger.severe(e);
                    }
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
