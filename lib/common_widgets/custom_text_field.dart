import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randolina/constants/app_colors.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    Key? key,
    this.title,
    this.titleStyle,
    this.hintText,
    this.maxLength,
    required this.onChanged,
    this.isEnabled = true,
    required this.validator,
    this.isPhoneNumber = false,
    this.initialValue,
    this.isPassword = false,
    this.prefix,
    this.textInputAction,
    this.lines,
  }) : super(key: key);

  final String? title;
  final TextStyle? titleStyle;
  final String? initialValue;
  final String? hintText;
  final int? maxLength;
  final bool isPassword;
  final ValueChanged<String> onChanged;
  final bool isPhoneNumber;
  final bool isEnabled;
  final FormFieldValidator<String> validator;
  final Widget? prefix;
  final TextInputAction? textInputAction;
  final int? lines;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: BorderedText(
                strokeColor: Colors.black,
                strokeWidth: 3.0,
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
          ],
          // because it not redondant
          // ignore: avoid_unnecessary_containers
          Container(
            child: TextFormField(
              minLines: lines,
              maxLines: ((lines ?? 0) > 1) ? lines : 1,
              textInputAction: textInputAction,
              enabled: isEnabled,
              initialValue: initialValue,
              keyboardType:
                  isPhoneNumber ? TextInputType.phone : TextInputType.text,
              // inputFormatters: [inputFormatter],
              maxLength: maxLength,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                prefixIcon: prefix,
                hintText: hintText,
                fillColor: Colors.white,
                filled: true,
                counterText: '',
                focusColor: backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueGrey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              obscureText: isPassword,
              onChanged: (value) => onChanged(value),
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
        ],
      ),
    );
  }
}
