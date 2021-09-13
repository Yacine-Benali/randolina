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
import 'package:randolina/constants/assets_constants.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class SignUpAgencyForm extends StatefulWidget {
  const SignUpAgencyForm({
    Key? key,
    required this.onSaved,
  }) : super(key: key);
  final void Function({
    required String fullname,
    required String clubname,
    required Timestamp creationDate,
    required String address,
  }) onSaved;

  @override
  _SignUpAgencyFormState createState() => _SignUpAgencyFormState();
}

class _SignUpAgencyFormState extends State<SignUpAgencyForm> {
  late String fullname;
  late String agencyname;
  Timestamp? creationDate;
  late String address;

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
      backgroundImagePath: agencyBackgroundImage,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30),
          SignUpTitle(title: 'Login information'),
          SizedBox(height: 30),
          SignUpDivider(
              imagePath: 'assets/sign_up/icons/1.png', start: 1, end: 10),
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
                      fillColor: Colors.white70,
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
                      fillColor: Colors.white70,
                      title: 'Agency name:',
                      hintText: 'Agency name...',
                      textInputAction: TextInputAction.next,
                      onChanged: (var value) {
                        agencyname = value;
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
                    title: 'creation date',
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
                      fillColor: Colors.white70,
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
                          clubname: agencyname,
                          creationDate: creationDate!,
                          address: address,
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
