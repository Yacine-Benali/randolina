import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_in/sign_in_bloc.dart';
import 'package:randolina/app/auth/sign_up/sign_up_screen.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/utils/validators.dart';

/* 
  ? todo add focus node and when clicking on next you move to the next field
  ? add input validation as the user types 
*/

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final SignInBloc bloc;
  String? username;
  String? password;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final Auth auth = context.read<Auth>();
    bloc = SignInBloc(auth: auth);
    super.initState();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate() &&
        username != null &&
        password != null) {
      try {
        await bloc.signIn(username!, password!);
      } on Exception catch (e) {
        PlatformExceptionAlertDialog(exception: e).show(context);
      }
    }
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Don't have an account ?",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(41, 67, 107, 1.0),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) {
                  return SignUpScreen();
                },
              ),
            );
          },
          child: Text(
            'Creat an account Now',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(64, 163, 219, 1.0),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return CustomElevatedButton(
      buttonText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'SIGN IN',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 30,
          ),
        ],
      ),
      onPressed: _signIn,
      minHeight: 35,
      minWidth: 200,
    );
  }

  List<Widget> _buildInput() {
    return [
      CustomTextForm(
        hintText: 'User Name...',
        textInputAction: TextInputAction.next,
        onChanged: (var value) {
          username = value;
        },
        validator: (String? value) {
          if (!Validators.isValidUsername(value)) {
            return invalidUsernameSignInError;
          }
          return null;
        },
      ),
      CustomTextForm(
        hintText: 'Password...',
        isPassword: true,
        textInputAction: TextInputAction.done,
        onChanged: (var t) {
          password = t;
        },
        validator: (String? value) {
          if (!Validators.isValidPassword(value)) {
            return invalidPasswordError;
          }
          return null;
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 180, bottom: 80),
                child: Image.asset(
                  'assets/logo_2.png',
                  width: 700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ..._buildInput(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password ?',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: _buildSignInButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Divider(
                        thickness: 1,
                        color: Color.fromRGBO(41, 67, 107, 1.0),
                      ),
                    ),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
