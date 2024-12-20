import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/sign_up_title.dart';
import 'package:randolina/common_widgets/signup_divider.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/utils/validators.dart';

class SignUpPhoneConfirmation extends StatefulWidget {
  const SignUpPhoneConfirmation({
    Key? key,
    required this.onNextPressed,
    required this.backgroundImagePath,
  }) : super(key: key);

  final ValueChanged<String> onNextPressed;
  final String backgroundImagePath;

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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: widget.backgroundImagePath,
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 30),
          SignUpTitle(title: 'confirmation du numéro'),
          SizedBox(height: 30),
          SignUpDivider(
            imagePath: 'assets/sign_up/icons/phone_confirmation_icon.png',
            start: 1,
            end: 1,
          ),
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
                      'pour confirmer votre numéro, entrez le code SMS ici :',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  CustomTextForm(
                    fillColor: Colors.white70,
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
                      Text('Suivant'),
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
