import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/description.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/followers_header.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/header_top_part.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/image_profile.dart';

class ClientHeader extends StatefulWidget {
  const ClientHeader({Key? key}) : super(key: key);

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
              ClientHeaderTopPart(),
              Description(
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
        ),
        ImageProfile(isExpanded: isExpanded),
      ],
    );
  }
}
