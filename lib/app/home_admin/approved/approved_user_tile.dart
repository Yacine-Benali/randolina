import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home_admin/approved/approved_bloc.dart';
import 'package:randolina/app/home_admin/approved/nested_screens/club_detail_screen.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';

import 'nested_screens/agency_detail_screen.dart';

class ApprovedUserTile extends StatelessWidget {
  const ApprovedUserTile({
    Key? key,
    required this.user,
    required this.bloc,
  }) : super(key: key);

  final User user;
  final ApprovedBloc bloc;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(47),
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: user.profilePicture,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      title: Text(user.name),
      subtitle: Text(user.username),
      onTap: () {
        if (user is Club) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ClubDetailScreen(club: user as Club, bloc: bloc),
            ),
          );
        }
        if (user is Agency) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AgencyDetailScreen(agency: user as Agency, bloc: bloc),
            ),
          );
        }
      },
    );
  }
}
