import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/user.dart';

class TypeOfUser extends StatelessWidget {
  const TypeOfUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();
    return Text(
      'Vloger',
      style: TextStyle(
        fontSize: 14,
        color: Color(0xFF40A3DB),
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
