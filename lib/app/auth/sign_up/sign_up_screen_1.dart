import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/constants/app_colors.dart';

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({Key? key}) : super(key: key);

  @override
  _SignUpScreen1State createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  Role _role = Role.A;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Text('Click on the correct option'),
          ListTile(
            title: Text(Role.A.toString()),
            leading: Radio<Role>(
              value: Role.A,
              activeColor: Colors.green,
              groupValue: _role,
              onChanged: (Role? value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text(Role.B.toString()),
            leading: Radio<Role>(
              value: Role.B,
              activeColor: Colors.green,
              groupValue: _role,
              onChanged: (Role? value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text(Role.C.toString()),
            leading: Radio<Role>(
              value: Role.C,
              activeColor: Colors.green,
              groupValue: _role,
              onChanged: (Role? value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text(Role.D.toString()),
            leading: Radio<Role>(
              value: Role.D,
              activeColor: Colors.green,
              groupValue: _role,
              onChanged: (Role? value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0)
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
                colors: [gradientStart, gradientEnd],
              ),
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(60),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                minimumSize: MaterialStateProperty.all(Size(120, 35)),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text('Next'),
            ),
          )
        ],
      ),
    );
  }
}
