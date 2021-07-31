import 'dart:io';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:randolina/common_widgets/avatar.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
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

class SignUpClubForm3 extends StatefulWidget {
  const SignUpClubForm3({
    Key? key,
    required this.onSaved,
  }) : super(key: key);

  final void Function({
    required File imageFile,
    required String? bio,
    required List<String> clubActivities,
  }) onSaved;
  @override
  _SignUpClubForm3State createState() => _SignUpClubForm3State();
}

class _SignUpClubForm3State extends State<SignUpClubForm3> {
  late final GlobalKey<FormState> _formKey;
  File? imageFile;
  String? bio;
  late List<String> clubActivities;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: clubBackgroundImage,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30),
          SignUpTitle(title: 'Complete the registration'),
          SizedBox(height: 30),
          SignUpDivider(
              imagePath: 'assets/sign_up_mini_icons/correct_icon.png',
              start: 1,
              end: 10),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MultiSelectFormField(
                      validator: (values) {
                        if (values != null) {
                          final List<dynamic> temp = values as List<dynamic>;

                          if (temp.isEmpty) {
                            return invalidClubActivitiesError;
                          }
                        } else {
                          return invalidClubActivitiesError;
                        }
                      },
                      chipBackGroundColor: gradientStart,
                      //  errorText: '*',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      chipLabelStyle: TextStyle(color: Colors.white),
                      dialogTextStyle: TextStyle(color: Colors.black),
                      checkBoxActiveColor: Colors.blue,
                      checkBoxCheckColor: Colors.white,
                      title: BorderedText(
                        strokeColor: Colors.black,
                        strokeWidth: 3.0,
                        child: Text(
                          'Choose activities',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      dataSource: [
                        {
                          'display': 'Kayak',
                          'value': 'Kayak',
                        },
                        {
                          'display': 'Hiking',
                          'value': 'Hiking',
                        },
                        {
                          'display': 'Voyage OR',
                          'value': 'Voyage OR',
                        },
                        {
                          'display': 'Bivouac',
                          'value': 'Bivouac',
                        },
                        {
                          'display': 'Jet ski',
                          'value': 'Jet ski',
                        },
                        {
                          'display': 'Parachute',
                          'value': 'Parachute',
                        },
                        {
                          'display': 'Diving',
                          'value': 'Diving',
                        },
                        {
                          'display': 'Mountaineering',
                          'value': 'Mountaineering',
                        },
                        {
                          'display': 'Others...',
                          'value': 'Others...',
                        },
                      ],
                      textField: clubKey,
                      valueField: clubValue,
                      hintWidget: Text(
                        'Please choose one or more activities',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onSaved: (values) {
                        if (values == null) return;
                        final List<String> temp = (values as List<dynamic>)
                            .map((e) => e.toString())
                            .toList();
                        setState(() {
                          clubActivities = temp;
                        });
                      },
                    ),
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
                        clubActivities: clubActivities,
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
