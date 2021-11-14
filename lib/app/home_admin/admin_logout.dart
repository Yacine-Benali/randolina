import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/services/auth.dart';

class AdminLogout extends StatelessWidget {
  const AdminLogout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<Auth>().signOut();
      },
      icon: Icon(Icons.logout, color: Colors.black),
    );
  }
}
