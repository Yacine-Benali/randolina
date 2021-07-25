import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/role_form/sign_up_role_form.dart';
import 'package:randolina/app/auth/sign_up/sign_up_screen_2.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Role? selectedRole;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: SignUpRoleForm(
        onChanged: (Role? value) {
          selectedRole = value;
        },
        onNextPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SignUpScreen2(
                role: selectedRole!,
              ),
            ),
          );
        },
      ),
    );
  }
}
