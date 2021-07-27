import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/client/sign_up_client_form.dart';
import 'package:randolina/app/auth/sign_up/client/sign_up_client_form2.dart';
import 'package:randolina/app/auth/sign_up/sign_up_bloc.dart';
import 'package:randolina/app/auth/sign_up/sign_up_phone_confirmation.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/app_constants.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';

class SignUpClientScreen extends StatefulWidget {
  const SignUpClientScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenClientState createState() => _SignUpScreenClientState();
}

class _SignUpScreenClientState extends State<SignUpClientScreen> {
  late final SignUpBloc bloc;
  late final PageController _pageController;
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    _pageController = PageController();
    final Auth auth = context.read<Auth>();
    final Database database = context.read<Database>();
    bloc = SignUpBloc(auth: auth, database: database);
    userInfo = <String, dynamic>{};

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
    return CustomScaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.screenHeight + 19,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              SignUpClientForm(
                onNextPressed: (Map<String, dynamic> info) async {
                  userInfo.addAll(info);
                  userInfo.addAll({'type': Role.client});
                  logger.info(userInfo);
                  try {
                    await bloc
                        .verifyPhoneNumber(userInfo['phoneNumber'] as String);
                    swipePage(1);
                  } on Exception catch (e) {
                    logger.severe('Error in verifyPhoneNumber');
                    PlatformExceptionAlertDialog(exception: e).show(context);
                  }
                },
              ),
              SignUpPhoneConfirmation(
                userInfo: userInfo,
                bloc: bloc,
                onNextPressed: (String code) async {
                  try {
                    final bool isLoggedIn = await bloc.magic(
                      userInfo['username'] as String,
                      userInfo['password'] as String,
                      code,
                    );
                    if (isLoggedIn) {
                      swipePage(2);
                    }
                  } on Exception catch (e) {
                    PlatformExceptionAlertDialog(exception: e).show(context);
                  }
                },
              ),
              SignUpClientForm2(
                onNextPressed: (Map<String, dynamic> info) {
                  userInfo.addAll(info);
                  userInfo.addAll({'type': Role.client});
                  logger.info(userInfo);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
