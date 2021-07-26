import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/role_selector/role_selector_radio.dart';
import 'package:randolina/app/auth/sign_up/sign_up_screen.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/strings.dart';

class RoleSelectorScreen extends StatefulWidget {
  const RoleSelectorScreen({
    Key? key,
    // required this.onNextPressed,
    // required this.onChanged,
  }) : super(key: key);
  // final VoidCallback onNextPressed;
  // final ValueChanged<Role?> onChanged;
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
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text('Click on the correct option to choose'),
            SizedBox(height: 40),
            Column(
              children: Role.values.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RoleSelectorRadio(
                    groupValue: selectedRole,
                    value: e,
                    onChanged: (Role? value) {
                      setState(() {
                        selectedRole = value;
                      });
                      // widget.onChanged(selectedRole);
                    },
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomElevatedButton(
                buttonText: Text('Next'),
                minHeight: 35,
                minWidth: 130,
                onPressed: selectedRole == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            fullscreenDialog: true,
                            builder: (_) => SignUpScreen(),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
