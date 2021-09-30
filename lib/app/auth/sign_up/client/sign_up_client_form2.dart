import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randolina/common_widgets/avatar.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_drop_down.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/sign_up_title.dart';
import 'package:randolina/common_widgets/signup_divider.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/app_constants.dart';
import 'package:randolina/constants/assets_constants.dart';
import 'package:randolina/constants/strings.dart';

class SignUpClientForm2 extends StatefulWidget {
  const SignUpClientForm2({
    Key? key,
    required this.onSaved,
  }) : super(key: key);

  final void Function({
    required File imageFile,
    required String? bio,
    required String activity,
  }) onSaved;
  @override
  _SignUpClientForm2State createState() => _SignUpClientForm2State();
}

class _SignUpClientForm2State extends State<SignUpClientForm2> {
  late final GlobalKey<FormState> _formKey;
  File? imageFile;
  String? bio;
  late String activity;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: backgroundColor,
      backgroundImagePath: clientBackgroundImage,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30),
          SignUpTitle(title: 'Complete the registration'),
          SizedBox(height: 30),
          SignUpDivider(
              imagePath: 'assets/sign_up/icons/correct_icon.png',
              start: 10,
              end: 1),
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
                        'assets/sign_up/client_upload_picture.png',
                        width: 150,
                      ),
                      onChanged: (File f) {
                        imageFile = f;
                      },
                    ),
                  ),
                  CustomTextForm(
                    fillColor: Colors.white70,
                    lines: 4,
                    hintText: 'Bio...',
                    maxLength: 200,
                    onChanged: (String value) {
                      bio = value;
                    },
                    validator: (v) {
                      if (v != null) {
                        final numLines = '\n'.allMatches(v).length + 1;
                        if (numLines > 3) {
                          return 'le nombre de lignes ne peut pas dépasser 3';
                        }
                      }
                    },
                  ),
                  CustomDropDown(
                    fillColor: Colors.white70,
                    validator: (String? value) {
                      if (value == null) {
                        return invalidActivityError;
                      }
                      return null;
                    },
                    title: 'Activité:',
                    hint: 'choisi...',
                    options: clientActivities,
                    onChanged: (String value) {
                      activity = value;
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: CustomElevatedButton(
              minHeight: 35,
              minWidth: 150,
              buttonText: Text('Finir'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // widget.onNextPressed(summery);
                  try {
                    if (imageFile != null) {
                      widget.onSaved(
                        imageFile: imageFile!,
                        bio: bio,
                        activity: activity,
                      );
                    } else {
                      throw PlatformException(
                        code: 'PROFILE_PICTURE_NULL',
                        message: 'La photo de profil est obligatoire',
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
