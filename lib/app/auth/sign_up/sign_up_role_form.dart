import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/constants/strings.dart';

class SignUpRoleForm extends StatefulWidget {
  const SignUpRoleForm({
    Key? key,
    required this.onNextPressed,
    required this.onChanged,
  }) : super(key: key);

  final VoidCallback onNextPressed;
  final ValueChanged<Map<String, dynamic>> onChanged;

  @override
  _SignUpRoleFormState createState() => _SignUpRoleFormState();
}

class _SignUpRoleFormState extends State<SignUpRoleForm> {
  late final GlobalKey<FormBuilderState> _fbKey;
  late FocusNode state;

  @override
  void initState() {
    _fbKey = GlobalKey<FormBuilderState>();
    state = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Click on the correct option'),
          FormBuilder(
            key: _fbKey,
            child: FormBuilderRadioGroup(
              activeColor: Colors.green,
              decoration: InputDecoration(border: InputBorder.none),
              options: Role.values
                  .map(
                    (lang) => FormBuilderFieldOption(
                      value: lang,
                      child: Image.asset(
                        'assets/logo.png',
                        height: 100,
                      ),
                    ),
                  )
                  .toList(growable: false),
              name: 'type',
              validator: FormBuilderValidators.required(context),
              controlAffinity: ControlAffinity.leading,
            ),
          ),
          CustomElevatedButton(
            buttonText: 'Next',
            minHeight: 35,
            minWidth: 120,
            onPressed: () {
              if (_fbKey.currentState!.saveAndValidate()) {
                //  print(_fbKey.currentState!.value);

                widget.onChanged(_fbKey.currentState!.value);
                widget.onNextPressed();
              } else {
                print("validation failed");
              }
            },
          ),
        ],
      ),
    );
  }
}
