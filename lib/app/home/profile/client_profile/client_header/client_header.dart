import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/description.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/header_top_part.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/common_widgets/followers_header.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/common_widgets/visit_followers_header.dart';

class ClientHeader extends StatefulWidget {
  const ClientHeader({
    Key? key,
    required this.client,
    required this.showProfileAsOther,
    required this.isFollowingOther,
    required this.onEditPressed,
    required this.onSavePressed,
    this.profileBloc,
  }) : super(key: key);
  final Client client;
  final bool showProfileAsOther;
  final bool? isFollowingOther;
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final ProfileBloc? profileBloc;

  @override
  _ClientHeaderState createState() => _ClientHeaderState();
}

class _ClientHeaderState extends State<ClientHeader> {
  bool isExpanded = false;
//! todo waiting on client feedback about moving profile picture when clicking
// more less
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          color: Colors.red[200],
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                ClientHeaderTopPart(
                  onSavePressed: widget.onSavePressed,
                  client: widget.client,
                  showProfileAsOther: widget.showProfileAsOther,
                  onEditPressed: widget.onEditPressed,
                  isFollowingOther: widget.isFollowingOther,
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
        ),
        if (!widget.showProfileAsOther) ...[
          Positioned(
            right: SizeConfig.blockSizeHorizontal * 7.7,
            bottom: SizeConfig.blockSizeVertical * 1,
            child: FollowersHeader(
              following: widget.client.following,
              followers: widget.client.followers,
            ),
          ),
        ],
        if (widget.showProfileAsOther && widget.isFollowingOther != null) ...[
          Positioned(
            right: 30,
            bottom: isExpanded ? 20 : 30,
            child: VisitFollowersHeader(
              isExpanded: isExpanded,
              isFollowing: widget.isFollowingOther!,
              followers: widget.client.followers,
            ),
          ),
        ],
        Positioned(
          bottom: SizeConfig.blockSizeVertical * 7,
          left: SizeConfig.blockSizeHorizontal * 4,
          child: ImageProfile(
            url: widget.client.profilePicture,
          ),
        ),
      ],
    );
  }
}
