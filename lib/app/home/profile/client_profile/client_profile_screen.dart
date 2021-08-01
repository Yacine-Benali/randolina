import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';

class ClientProfileScreen extends StatefulWidget {
  ClientProfileScreen({Key? key}) : super(key: key);

  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClientHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
