import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/models/client.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({Key? key, required this.client}) : super(key: key);
  final Client client;

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
            ClientHeader(client: widget.client),
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
