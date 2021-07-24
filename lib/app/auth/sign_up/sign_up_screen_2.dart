import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/constants/app_colors.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({Key? key, required this.role}) : super(key: key);
  final Role role;

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text('Login'),
          Row(children: <Widget>[
            Expanded(
              child: Divider(),
            ),
            Icon(Icons.ac_unit),
            Expanded(
              flex: 4,
              child: Divider(),
            ),
          ]),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
                child: Column(
              children: [
                CustomTextForm(
                  title: 'full name',
                  hintText: 'hintText',
                  maxLength: 5,
                  onChanged: (var t) {},
                  isEnabled: true,
                  initialValue: null,
                  validator: (String? value) {
                    if (value != null) {
                      if (value.length > 3) return 'fuck u';
                    }
                    return null;
                  },
                ),
              ],
            )),
          )
        ],
      )),
    );
  }
}
