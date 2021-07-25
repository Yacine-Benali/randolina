import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    Key? key,
    required this.title,
    this.hintText,
    required this.maxLength,
    required this.onChanged,
    this.isEnabled = true,
    required this.validator,
    this.isPhoneNumber = false,
    this.initialValue,
    this.isPassword = false,
    this.prefix,
  }) : super(key: key);

  final String title;
  final String? initialValue;
  final String? hintText;
  final int maxLength;
  final bool isPassword;
  final ValueChanged<String> onChanged;
  final bool isPhoneNumber;
  final bool isEnabled;
  final FormFieldValidator<String> validator;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            // decoration: BoxDecoration(
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.grey.withOpacity(0.6),
            //       offset: Offset(0, 5),
            //       blurRadius: 15.0,
            //     )
            //   ],
            // ),
            child: TextFormField(
              enabled: isEnabled,
              initialValue: initialValue,
              keyboardType:
                  isPhoneNumber ? TextInputType.phone : TextInputType.text,
              // inputFormatters: [inputFormatter],
              maxLength: maxLength,
              decoration: InputDecoration(
                prefixIcon: prefix,
                hintText: hintText,
                fillColor: Colors.white,
                filled: true,
                counterText: '',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(119, 138, 164, 1),
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              obscureText: isPassword,
              onChanged: (value) => onChanged(value),
              validator: validator,
              autovalidateMode: AutovalidateMode.always,
            ),
          ),
        ],
      ),
    );
  }
}
