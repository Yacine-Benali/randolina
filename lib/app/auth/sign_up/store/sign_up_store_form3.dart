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

class SignUpStoreForm3 extends StatefulWidget {
  const SignUpStoreForm3({
    Key? key,
    required this.onSaved,
  }) : super(key: key);

  final void Function({
    required File imageFile,
    required String? bio,
  }) onSaved;
  @override
  _SignUpStoreForm3State createState() => _SignUpStoreForm3State();
}

class _SignUpStoreForm3State extends State<SignUpStoreForm3> {
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
            imagePath: 'assets/sign_up/icons/correct_icon.png',
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
                        'assets/sign_up/club_upload_picture.png',
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
                    hintText: 'Bio...(vous pouvez mettre votre site ici)',
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
                        message:
                            'La photo de profil est obligatoireis mandatory',
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
