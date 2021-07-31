import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randolina/app/auth/sign_up/custom_sign_up_title.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_drop_down.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/date_picker.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/constants/assets_constants.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class SignUpClientForm extends StatefulWidget {
  const SignUpClientForm({
    Key? key,
    required this.onSaved,
  }) : super(key: key);
  final void Function({
    required String fullname,
    required String username,
    required int wilaya,
    required String password,
    required String phoneNumber,
    required Timestamp dateOfBirth,
  }) onSaved;

  @override
  _SignUpClientFormState createState() => _SignUpClientFormState();
}

class _SignUpClientFormState extends State<SignUpClientForm> {
  late String fullname;
  late String username;
  late int wilaya;
  late String password;
  late String phoneNumber;
  Timestamp? dateOfBirth;
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
    final padding = EdgeInsets.symmetric(vertical: 1);
    return CustomScaffold(
      backgroundImagePath: clientBackgroundImage,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            CustomSignUpTitle(title: 'Login information'),
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
                        title: 'User Name:',
                        hintText: 'User Name...',
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
                      child: CustomDropDown(
                        title: 'Wilaya',
                        hint: 'Wilaya',
                        validator: (String? value) {
                          if (value == null) {
                            return invalidWilayaError;
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          if (value == null) {
                          } else {
                            final int? wilayaN =
                                int.tryParse(value[0] + value[1]);

                            wilaya = wilayaN!;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: padding,
                      child: DatePicker(
                        title: 'date of birth',
                        hintText: 'DD/MM/YYYY',
                        selectedDate: dateOfBirth,
                        onSelectedDate: (Timestamp date) {
                          setState(() {
                            dateOfBirth = date;
                          });
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
                        isPhoneNumber: true,
                        onChanged: (var value) {
                          phoneNumber = value;
                          phoneNumber =
                              phoneNumber.replaceFirst(RegExp('0'), '');
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
                        if (dateOfBirth == null) {
                          final PlatformException e = PlatformException(
                            code: 'BIRTHDAY_NULL',
                            message: 'You must select a birthday',
                          );
                          PlatformExceptionAlertDialog(exception: e)
                              .show(context);
                        } else {
                          widget.onSaved(
                            fullname: fullname,
                            username: username,
                            wilaya: wilaya,
                            password: password,
                            phoneNumber: phoneNumber,
                            dateOfBirth: dateOfBirth!,
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
      ),
    );
  }
}
