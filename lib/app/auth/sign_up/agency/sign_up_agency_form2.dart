import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/sign_up_title.dart';
import 'package:randolina/common_widgets/signup_divider.dart';
import 'package:randolina/constants/assets_constants.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class SignUpAgencyForm2 extends StatefulWidget {
  const SignUpAgencyForm2({
    Key? key,
    required this.onSaved,
  }) : super(key: key);
  final void Function({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) onSaved;

  @override
  _SignUpAgencyForm2State createState() => _SignUpAgencyForm2State();
}

class _SignUpAgencyForm2State extends State<SignUpAgencyForm2> {
  late String username;
  late String email;
  late String password;
  late String phoneNumber;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(vertical: 1);
    return CustomScaffold(
      backgroundImagePath: agencyBackgroundImage,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30),
          SignUpTitle(title: 'Login information'),
          SizedBox(height: 30),
          SignUpDivider(
              imagePath: 'assets/club_signup/2.png', start: 1, end: 10),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: padding,
                    child: CustomTextForm(
                      title: 'Use name:',
                      hintText: 'User name...',
                      maxLength: 50,
                      textInputAction: TextInputAction.next,
                      onChanged: (var value) {
                        username = value;
                      },
                      validator: (String? value) {
                        if (!Validators.isValidUsername(value)) {
                          return invalidUsernameSignUpError;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: CustomTextForm(
                      title: 'Email',
                      hintText: 'Examle@gmail.co...',
                      textInputAction: TextInputAction.next,
                      onChanged: (var value) {
                        email = value;
                      },
                      validator: (String? value) {
                        if (!Validators.isValidEmail(value)) {
                          return invalidEmailError;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: CustomTextForm(
                      title: 'Password:',
                      hintText: 'Password...',
                      isPassword: true,
                      textInputAction: TextInputAction.next,
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
                  ),
                  Padding(
                    padding: padding,
                    child: CustomTextForm(
                      title: 'Phone number:',
                      maxLength: 10,
                      textInputAction: TextInputAction.done,
                      isPhoneNumber: true,
                      onChanged: (var value) {
                        phoneNumber = value;
                        phoneNumber = phoneNumber.replaceFirst(RegExp('0'), '');
                        phoneNumber = '+213$phoneNumber';
                      },
                      prefix: Padding(
                        //padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        padding: const EdgeInsets.all(0),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '+213',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: 57,
                                child: VerticalDivider(
                                  thickness: 1,
                                  width: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || !value.startsWith('0')) {
                          return invalidPhoneNumberError;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomElevatedButton(
                  minHeight: 35,
                  minWidth: 150,
                  buttonText: SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 30),
                        Text('Next'),
                        Icon(
                          Icons.chevron_right,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      widget.onSaved(
                        username: username,
                        email: email,
                        password: password,
                        phoneNumber: phoneNumber,
                      );
                    }
                  }),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
