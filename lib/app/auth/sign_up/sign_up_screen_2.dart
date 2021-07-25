import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/wilaya_picker.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Login information'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextForm(
                    title: 'Full name:',
                    hintText: 'Name...',
                    maxLength: 5,
                    onChanged: (var t) {},
                    validator: (String? value) {
                      if (value != null) {
                        if (value.length > 3) return 'fuck u';
                      }
                      return null;
                    },
                  ),
                  CustomTextForm(
                    title: 'User Name:',
                    hintText: 'User Name...',
                    maxLength: 5,
                    onChanged: (var t) {},
                    validator: (String? value) {
                      if (value != null) {
                        if (value.length > 3) return 'fuck u';
                      }
                      return null;
                    },
                  ),
                  WilayaPicker(),
                  CustomTextForm(
                    title: 'Password:',
                    hintText: 'Password...',
                    maxLength: 5,
                    isPassword: true,
                    onChanged: (var t) {},
                    validator: (String? value) {
                      if (value != null) {
                        if (value.length > 3) return 'fuck u';
                      }
                      return null;
                    },
                  ),
                  CustomTextForm(
                    title: 'Phone number:',
                    maxLength: 5,
                    onChanged: (var t) {},
                    prefix: Padding(
                      //padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                      padding: const EdgeInsets.all(0),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '+213',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 57,
                              child: VerticalDivider(
                                thickness: 1,
                                width: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value != null) {
                        if (value.length > 3) return 'fuck u';
                      }
                      return null;
                    },
                  ),
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomElevatedButton(
                  buttonText: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Next'),
                      SizedBox(width: 20),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                  onPressed: () {},
                  minHeight: 35,
                  minWidth: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
