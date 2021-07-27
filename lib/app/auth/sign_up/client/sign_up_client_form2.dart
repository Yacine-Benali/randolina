import 'dart:io';

import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/avatar.dart';
import 'package:randolina/common_widgets/custom_drop_down.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/constants/app_constants.dart';

class SignUpClientForm2 extends StatefulWidget {
  const SignUpClientForm2({
    Key? key,
    required this.onNextPressed,
  }) : super(key: key);
  final ValueChanged<Map<String, dynamic>> onNextPressed;

  @override
  _SignUpClientForm2State createState() => _SignUpClientForm2State();
}

class _SignUpClientForm2State extends State<SignUpClientForm2> {
  late final GlobalKey<FormState> _formKey;
  String? bio;
  String? activity;
  File? imageFile;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  Widget buildDivider() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Divider(
            thickness: 1,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ),
        Image.asset(
          'assets/correct_icon.png',
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Text('Complete the registration'),
        SizedBox(height: 30),
        buildDivider(),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    bottom: 16.0,
                  ),
                  child: Avatar(
                    onChanged: (File f) {
                      imageFile = f;
                    },
                  ),
                ),
                CustomTextForm(
                  lines: 4,
                  hintText: 'Bio...',
                  onChanged: (String value) {
                    bio = value;
                  },
                  validator: (v) {},
                ),
                CustomDropDown(
                  title: 'Activity:',
                  hint: 'Chose...',
                  options: clientActivities,
                  onChanged: (String value) {
                    activity = value;
                  },
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CustomElevatedButton(
                minHeight: 35,
                minWidth: 150,
                buttonText: Text('Finish'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // widget.onNextPressed(summery);
                    Map<String, dynamic> userInfo = {
                      'bio': bio,
                      'activity': activity,
                      'profilePicture': imageFile,
                    };

                    widget.onNextPressed(userInfo);
                  }
                },
              ),
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
