import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_drop_down.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/date_picker.dart';
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
    required int wilaya,
    required int members,
  }) onSaved;

  @override
  _SignUpClubFormState createState() => _SignUpClubFormState();
}

class _SignUpClubFormState extends State<SignUpClubForm> {
  late String fullname;
  late String clubname;
  late Timestamp creationDate;
  late int wilaya;
  late int members;

  late final GlobalKey<FormState> _formKey;
  bool isButtonEnabled = true;

  @override
  void initState() {
    creationDate = Timestamp.now();
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
                  labelText: 'date de creation',
                  selectedDate: creationDate,
                  onSelectedDate: (selectedDate) {
                    setState(() {
                      creationDate = selectedDate;
                    });
                  },
                ),
                Padding(
                  padding: padding,
                  child: CustomDropDown(
                    title: 'Localisation',
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
                        final int? wilayaN = int.tryParse(value[0] + value[1]);

                        wilaya = wilayaN!;
                      }
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
                    widget.onSaved(
                      fullname: fullname,
                      clubname: clubname,
                      creationDate: creationDate,
                      wilaya: wilaya,
                      members: members,
                    );
                  }
                }),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
