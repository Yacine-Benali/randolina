import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/sign_up_client_form1_1.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';

class RoleSelectorScreen2 extends StatefulWidget {
  const RoleSelectorScreen2({Key? key, required this.role}) : super(key: key);
  final Role role;

  @override
  _RoleSelectorScreen2State createState() => _RoleSelectorScreen2State();
}

class _RoleSelectorScreen2State extends State<RoleSelectorScreen2> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: SignUpClientForm1(),
    );
  }
}
