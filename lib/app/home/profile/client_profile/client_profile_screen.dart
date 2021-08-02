import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/user.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({Key? key, required this.client}) : super(key: key);
  final Client client;

  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
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
          if (user.id != widget.client.id) ...[
            Positioned(
              top: 5,
              left: 8,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.close,
                  color: Colors.black87,
                  size: 30,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
