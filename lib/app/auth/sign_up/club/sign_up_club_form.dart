import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/date_picker.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/sign_up_title.dart';
import 'package:randolina/common_widgets/signup_divider.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/assets_constants.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class SignUpClubForm extends StatefulWidget {
  const SignUpClubForm({
    Key? key,
    required this.onSaved,
  }) : super(key: key);
  final void Function({
    required String fullname,
    required String clubname,
    required Timestamp creationDate,
    required String address,
    required int members,
  }) onSaved;

  @override
  _SignUpClubFormState createState() => _SignUpClubFormState();
}

class _SignUpClubFormState extends State<SignUpClubForm> {
  late String fullname;
  late String clubname;
  Timestamp? creationDate;
  late String address;
  late int members;

  late final GlobalKey<FormState> _formKey;
  bool isButtonEnabled = true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(vertical: 1);
    return CustomScaffold(
      backgroundImagePath: clubBackgroundImage,
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30),
          SignUpTitle(title: 'Login information'),
          SizedBox(height: 30),
          SignUpDivider(
              imagePath: 'assets/club_signup/1.png', start: 1, end: 10),
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
                  ),
                  Padding(
                    padding: padding,
                    child: CustomTextForm(
                      title: 'Club name:',
                      hintText: 'Club name...',
                      textInputAction: TextInputAction.next,
                      onChanged: (var value) {
                        clubname = value;
                      },
                      validator: (String? value) {
                        if (!Validators.isValidName(value)) {
                          return invalidUsernameSignUpError;
                        }
                        return null;
                      },
                    ),
                  ),
                  DatePicker(
                    title: 'date of birth',
                    hintText: 'DD/MM/YYYY',
                    selectedDate: creationDate,
                    onSelectedDate: (Timestamp date) {
                      setState(() {
                        creationDate = date;
                      });
                    },
                  ),
                  Padding(
                    padding: padding,
                    child: CustomTextForm(
                      title: 'Localisation:',
                      hintText: 'Oran,Alger...',
                      textInputAction: TextInputAction.next,
                      onChanged: (var value) {
                        address = value;
                      },
                      validator: (String? value) {
                        if (!Validators.isValidName(value)) {
                          return invalidUsernameSignUpError;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: CustomTextForm(
                      title: 'Number of members:',
                      hintText: 'Number of members:',
                      maxLength: 6,
                      isPhoneNumber: true,
                      onChanged: (var value) {
                        members = int.parse(value);
                      },
                      validator: (String? value) {
                        if (!Validators.isValidNumber(value)) {
                          return invalidClubMembersError;
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
                      if (creationDate == null) {
                        final PlatformException e = PlatformException(
                          code: 'BIRTHDAY_NULL',
                          message: 'You must select a birthday',
                        );
                        PlatformExceptionAlertDialog(exception: e)
                            .show(context);
                      } else {
                        widget.onSaved(
                          fullname: fullname,
                          clubname: clubname,
                          creationDate: creationDate!,
                          address: address,
                          members: members,
                        );
                      }
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
