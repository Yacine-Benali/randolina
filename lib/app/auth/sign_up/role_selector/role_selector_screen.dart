import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/role_selector/role_selector_form.dart';
import 'package:randolina/app/auth/sign_up/sign_up_screen.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';

class RoleSelectorScreen extends StatefulWidget {
  const RoleSelectorScreen({Key? key}) : super(key: key);

  @override
  _RoleSelectorScreenState createState() => _RoleSelectorScreenState();
}

class _RoleSelectorScreenState extends State<RoleSelectorScreen> {
  Role? selectedRole;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: RoleSelectorForm(
        onChanged: (Role? value) {
          selectedRole = value;
        },
        onNextPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RoleSelectorScreen2(
                role: selectedRole!,
              ),
            ),
          );
        },
      ),
    );
  }
}
