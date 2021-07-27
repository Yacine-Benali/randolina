import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/client/sign_up_client_form.dart';
import 'package:randolina/app/auth/sign_up/sign_up_bloc.dart';
import 'package:randolina/app/auth/sign_up/sign_up_phone_confirmation.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/services/auth.dart';

class SignUpScreenClient extends StatefulWidget {
  const SignUpScreenClient({
    Key? key,
    required this.selectedRole,
  }) : super(key: key);
  final Role selectedRole;

  @override
  _SignUpScreenClientState createState() => _SignUpScreenClientState();
}

class _SignUpScreenClientState extends State<SignUpScreenClient> {
  late final SignUpBloc bloc;
  late final PageController _pageController;
  late final Box<Map<String, dynamic>> box;
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    _pageController = PageController();
    final Auth auth = context.read<Auth>();
    box = context.read<Box<Map<String, dynamic>>>();
    bloc = SignUpBloc(auth: auth, box: box);
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
          height: SizeConfig.screenHeight,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              SignUpClientForm(
                onNextPressed: (Map<String, dynamic> info) async {
                  userInfo.addAll(info);
                  userInfo.addAll({'type': widget.selectedRole.index});
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
                    bool tt = await bloc.magic(userInfo, code);
                    if (tt) {
                      Navigator.of(context).pop();
                    }
                  } on Exception catch (e) {
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
