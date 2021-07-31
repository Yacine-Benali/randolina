import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randolina/common_widgets/avatar.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/sign_up_title.dart';
import 'package:randolina/common_widgets/signup_divider.dart';
import 'package:randolina/constants/assets_constants.dart';

class SignUpAgencyForm3 extends StatefulWidget {
  const SignUpAgencyForm3({
    Key? key,
    required this.onSaved,
  }) : super(key: key);

  final void Function({
    required File imageFile,
    required String? bio,
  }) onSaved;
  @override
  _SignUpAgencyForm3State createState() => _SignUpAgencyForm3State();
}

class _SignUpAgencyForm3State extends State<SignUpAgencyForm3> {
  late final GlobalKey<FormState> _formKey;
  File? imageFile;
  String? bio;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: agencyBackgroundImage,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30),
          SignUpTitle(title: 'Complete the registration'),
          SizedBox(height: 30),
          SignUpDivider(
            imagePath: 'assets/sign_up_mini_icons/correct_icon.png',
            start: 10,
            end: 1,
          ),
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
                      placeHolder: Image.asset(
                        'assets/club_upload_picture.png',
                        width: 150,
                      ),
                      onChanged: (File f) {
                        imageFile = f;
                      },
                    ),
                  ),
                  CustomTextForm(
                    lines: 4,
                    hintText: 'Bio...',
                    maxLength: 200,
                    onChanged: (String value) {
                      bio = value;
                    },
                    validator: (v) {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: CustomElevatedButton(
              minHeight: 35,
              minWidth: 150,
              buttonText: Text('Finish'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    if (imageFile != null) {
                      widget.onSaved(
                        imageFile: imageFile!,
                        bio: bio,
                      );
                    } else {
                      throw PlatformException(
                        code: 'PROFILE_PICTURE_NULL',
                        message: 'Profile picture is mandatory',
                      );
                    }
                  } on Exception catch (e) {
                    PlatformExceptionAlertDialog(exception: e).show(context);
                  }
                }
              },
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
