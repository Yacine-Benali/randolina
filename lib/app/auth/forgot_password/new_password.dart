import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({
    Key? key,
    required this.onNextPressed,
  }) : super(key: key);
  final ValueChanged<String> onNextPressed;

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  String? password1;
  String? password2;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  Widget _buildSignInButton() {
    return CustomElevatedButton(
      buttonText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Save',
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
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (password1 != null && password2 != null) {
            if (password1 != password2) {
              PlatformExceptionAlertDialog(
                exception: PlatformException(
                  code: 'PASSWORDS_DOES_NOT_MATCH',
                  message:
                      'the two password does not match, please rewrite your password',
                ),
              ).show(context);
            } else {
              widget.onNextPressed(password1!);
            }
          }
        }
      },
      minHeight: 30,
      minWidth: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: SizedBox(
          height: SizeConfig.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 45,
                child: Image.asset(
                  'assets/home_logo.png',
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Enter your new password',
                textAlign: TextAlign.center,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextForm(
                      title: 'new assword:',
                      titleStyle: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        fontSize: 16,
                      ),
                      hintText: 'Password...',
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      onChanged: (var t) {
                        password1 = t;
                      },
                      validator: (String? value) {
                        if (!Validators.isValidPassword(value)) {
                          return invalidPasswordError;
                        }
                        return null;
                      },
                    ),
                    CustomTextForm(
                      hintText: 'Confirm your password...',
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      onChanged: (var t) {
                        password2 = t;
                      },
                      validator: (String? value) {
                        if (!Validators.isValidPassword(value)) {
                          return invalidPasswordError;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.blockSizeVertical * 30,
                ),
                child: _buildSignInButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
