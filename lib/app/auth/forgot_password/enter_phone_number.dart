import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/strings.dart';

class EnterPhoneNumber extends StatefulWidget {
  const EnterPhoneNumber({
    Key? key,
    required this.onNextPressed,
  }) : super(key: key);
  final ValueChanged<String> onNextPressed;

  @override
  _EnterPhoneNumberState createState() => _EnterPhoneNumberState();
}

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  String? phoneNumber;
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
              'Suivant',
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
          if (phoneNumber != null) {
            widget.onNextPressed(phoneNumber!);
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/home_logo.png',
                  ),
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1),
                  child: CustomTextForm(
                    title: 'Votre numéro de téléphone:',
                    titleStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6)),
                    maxLength: 10,
                    isPhoneNumber: true,
                    onChanged: (String value) {
                      phoneNumber = value;
                      phoneNumber = phoneNumber!.replaceFirst(RegExp('0'), '');
                      phoneNumber = '+213$phoneNumber';
                    },
                    prefix: IntrinsicHeight(
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
                    validator: (String? value) {
                      if (value == null || !value.startsWith('0')) {
                        return invalidPhoneNumberError;
                      }
                      return null;
                    },
                  ),
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
