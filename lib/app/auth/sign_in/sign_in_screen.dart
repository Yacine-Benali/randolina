import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/forgot_password/forgot_pass_screen.dart';
import 'package:randolina/app/auth/sign_in/sign_in_bloc.dart';
import 'package:randolina/app/auth/sign_up/sign_up_screen.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/utils/validators.dart';
import 'package:url_launcher/url_launcher.dart';

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
            "Vous n'avez pas de compte ?",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(41, 67, 107, 1.0),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final bool? isConfirmed = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("termes et conditions"),
                  content: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'acceptez-vous nos termes et conditions',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: ' détaillé ici',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  'https://drive.google.com/file/d/1bMmaTmJiYTDIGyzVUkJ7WMeL2HskNBlL/view?fbclid=IwAR13U7e_IjP9Pl_BcXTFKZ5g7uU_rWlSy8-ePeH7-hB8aCFS1-mAjtv1rRU';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("non", style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text("oui", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                );
              },
            );
            if (isConfirmed == true) {
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            }
          },
          child: Text(
            'Créer un compte maintenant',
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
              "S'IDENTIFIER",
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
        hintText: "Nom d'utilisateur...",
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
        hintText: 'Mot de passe...',
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 180,
                  bottom: 100,
                  right: 50,
                  left: 50,
                ),
                child: Image.asset(
                  'assets/home_logo.png',
                  width: 213,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) {
                                return ForgotPassScreen();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: _buildSignInButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
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
