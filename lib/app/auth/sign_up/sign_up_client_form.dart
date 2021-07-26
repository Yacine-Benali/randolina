import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/wilaya_picker.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/constants/validators.dart';

class SignUpClientForm extends StatefulWidget {
  const SignUpClientForm({
    Key? key,
    required this.onNextPressed,
  }) : super(key: key);
  final ValueChanged<Map<String, dynamic>> onNextPressed;

  @override
  _SignUpClientFormState createState() => _SignUpClientFormState();
}

class _SignUpClientFormState extends State<SignUpClientForm> {
  late String fullname;
  late int wilaya;
  late String username;
  late String password;
  late String phoneNumber;
  late final GlobalKey<FormState> _formKey;
  bool isButtonEnabled = true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  Widget buildDivider() {
    return Row(children: <Widget>[
      Expanded(
        child: Divider(
          thickness: 1,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      ),
      Image.asset(
        'assets/account.png',
      ),
      Expanded(
        flex: 10,
        child: Divider(
          thickness: 1,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Text('Login information'),
        SizedBox(height: 30),
        buildDivider(),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextForm(
                  title: 'Full name:',
                  hintText: 'Name...',
                  maxLength: 50,
                  textInputAction: TextInputAction.next,
                  onChanged: (var value) {
                    fullname = value;
                  },
                  validator: (String? value) {
                    if (!Validators.isValidName(value)) {
                      return wrongNameError;
                    }
                    return null;
                  },
                ),
                CustomTextForm(
                  title: 'User Name:',
                  hintText: 'User Name...',
                  textInputAction: TextInputAction.next,
                  onChanged: (var value) {
                    username = value;
                    print(value);
                  },
                  validator: (String? value) {
                    if (!Validators.isValidUsername(value)) {
                      return invalidUsernameError;
                    }
                    return null;
                  },
                ),
                WilayaPicker(
                  //todo this needs validation ?
                  onChanged: (int? value) {
                    if (value == null) {
                    } else {
                      wilaya = value;
                    }
                  },
                ),
                CustomTextForm(
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
                CustomTextForm(
                  title: 'Phone number:',
                  maxLength: 10,
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
              onPressed: isButtonEnabled
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        final Map<String, dynamic> summery = {
                          'fullname': fullname,
                          'wilaya': wilaya,
                          'username': username,
                          'phoneNumber': phoneNumber,
                          'password': password,
                        };
                        widget.onNextPressed(summery);
                      }
                    }
                  : null,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
