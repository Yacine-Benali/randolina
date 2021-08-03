import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/description.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/header_top_part.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/visit_followers_header.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/common_widgets/followers_header.dart';
import 'package:randolina/common_widgets/image_profile.dart';

class ClientHeader extends StatefulWidget {
  const ClientHeader({
    Key? key,
    required this.client,
    required this.showProfileAsOther,
    required this.isFollowingOther,
    required this.onEditPressed,
  }) : super(key: key);
  final Client client;
  final bool showProfileAsOther;
  final bool? isFollowingOther;
  final VoidCallback onEditPressed;

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
              ClientHeaderTopPart(
                client: widget.client,
                showEditButton: !widget.showProfileAsOther,
                onEditPressed: widget.onEditPressed,
              ),
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
        if (!widget.showProfileAsOther) ...[
          Positioned(
            right: 30,
            bottom: isExpanded ? 20 : 30,
            child: FollowersHeader(
              following: widget.client.following,
              followers: widget.client.followers,
            ),
          ),
        ],
        if (widget.showProfileAsOther && widget.isFollowingOther != null) ...[
          VisitFollowersHeader(
            isExpanded: isExpanded,
            isFollowing: widget.isFollowingOther!,
            followers: widget.client.followers,
          ),
        ],
        Positioned(
          bottom: isExpanded ? (58 + 30) : (42 + 30),
          left: 16,
          child: ImageProfile(
            url: widget.client.profilePicture,
          ),
        ),
      ],
    );
  }
}
