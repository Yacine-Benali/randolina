import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class ConfirmPhoneNumber extends StatefulWidget {
  const ConfirmPhoneNumber({
    Key? key,
    required this.onNextPressed,
  }) : super(key: key);

  final ValueChanged<String> onNextPressed;

  @override
  _ConfirmPhoneNumberState createState() => _ConfirmPhoneNumberState();
}

class _ConfirmPhoneNumberState extends State<ConfirmPhoneNumber> {
  late String? code;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  Widget _buildSignInButton() {
    return CustomElevatedButton(
      buttonText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 30,
          ),
        ],
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (code != null) {
            widget.onNextPressed(code!);
          }
        }
      },
      minHeight: 30,
      minWidth: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: SizedBox(
          height: SizeConfig.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 45,
                child: Image.asset(
                  'assets/home_logo.png',
                ),
              ),
              SizedBox(height: 30),
              Text(
                'to confirm your phone number, enter the SMS code here:',
                textAlign: TextAlign.center,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
              Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.blockSizeVertical * 30,
                ),
                child: _buildSignInButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
