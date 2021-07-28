import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/sign_up_bloc.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class SignUpPhoneConfirmation extends StatefulWidget {
  const SignUpPhoneConfirmation({
    Key? key,
    required this.onNextPressed,
    required this.bloc,
  }) : super(key: key);
  final ValueChanged<String> onNextPressed;
  final SignUpBloc bloc;

  @override
  _SignUpPhoneConfirmationState createState() =>
      _SignUpPhoneConfirmationState();
}

class _SignUpPhoneConfirmationState extends State<SignUpPhoneConfirmation> {
  late String code;
  late final GlobalKey<FormState> _formKey;

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
        'assets/phone_confirmation_logo.png',
      ),
      Expanded(
        child: Divider(
          thickness: 1,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: Column(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'to confirm your number, enter the SMS code here:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ),
                  ),
                  CustomTextForm(
                    title: '',
                    hintText: 'CODE',
                    maxLength: 6,
                    isPhoneNumber: true,
                    textInputAction: TextInputAction.done,
                    onChanged: (var value) {
                      code = value;
                    },
                    validator: (String? value) {
                      if (!Validators.isValidVerificationCode(value)) {
                        return invalidVerificationCodeError;
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.onNextPressed(code);
                  }
                },
              ),
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
