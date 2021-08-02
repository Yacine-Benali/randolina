import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/description.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/followers_header.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/header_top_part.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/image_profile.dart';
import 'package:randolina/app/models/client.dart';

class ClientHeader extends StatefulWidget {
  const ClientHeader({Key? key, required this.client}) : super(key: key);
  final Client client;

  @override
  _ClientHeaderState createState() => _ClientHeaderState();
}

class _ClientHeaderState extends State<ClientHeader> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        SizedBox(
          height: isExpanded ? 207 : 191,
          child: Column(
            children: [
              ClientHeaderTopPart(client: widget.client),
              Description(
                client: widget.client,
                isExpanded: isExpanded,
                onExpanded: (bool isExpanded) {
                  this.isExpanded = isExpanded;
                  setState(() {});
                },
              )
            ],
          ),
        ),
        FollowersHeader(
          isExpanded: isExpanded,
          following: widget.client.following,
          followers: widget.client.followers,
        ),
        ImageProfile(client: widget.client, isExpanded: isExpanded),
      ],
    );
  }
}
