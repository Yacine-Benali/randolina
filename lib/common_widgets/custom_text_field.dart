import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    Key? key,
    required this.title,
    required this.hintText,
    required this.maxLength,
    //  required this.inputFormatter,
    required this.onChanged,
    required this.isEnabled,
    //  required this.onSaved,
    this.isPhoneNumber = false,
    required this.initialValue,
    required this.validator,
  }) : super(key: key);

  final String title;
  final String? initialValue;
  final String hintText;
  final int maxLength;
//  final TextInputFormatter inputFormatter;
  // final ValueChanged<String> onSaved;
  final ValueChanged<String> onChanged;
  final bool isPhoneNumber;
  final bool isEnabled;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
          TextFormField(
            enabled: isEnabled,
            initialValue: initialValue,
            keyboardType:
                isPhoneNumber ? TextInputType.phone : TextInputType.text,
            // inputFormatters: [inputFormatter],
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: '',
            ),
            onChanged: (value) => onChanged(value),
            validator: validator,
            autovalidateMode: AutovalidateMode.always,
          ),
        ],
      ),
    );
  }
}
