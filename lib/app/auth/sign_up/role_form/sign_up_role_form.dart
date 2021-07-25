import 'package:flutter/material.dart';
import 'package:randolina/app/auth/sign_up/role_form/sign_up_radio.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/constants/strings.dart';

class SignUpRoleForm extends StatefulWidget {
  const SignUpRoleForm({
    Key? key,
    required this.onNextPressed,
    required this.onChanged,
  }) : super(key: key);

  final VoidCallback onNextPressed;
  final ValueChanged<Role?> onChanged;

  @override
  _SignUpRoleFormState createState() => _SignUpRoleFormState();
}

class _SignUpRoleFormState extends State<SignUpRoleForm> {
  Role? selectedRole;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Text('Click on the correct option to choose'),
          SizedBox(height: 40),
          Column(
            children: Role.values.map((e) {
              return SignUpRadio(
                groupValue: selectedRole,
                value: e,
                onChanged: (Role? value) {
                  setState(() {
                    selectedRole = value;
                  });
                  widget.onChanged(selectedRole);
                },
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
                      widget.onNextPressed();
                    },
            ),
          ),
        ],
      ),
    );
  }
}
