import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_top_header.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/followers_header.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/common_widgets/visit_followers_header.dart';
import 'package:readmore/readmore.dart';

class ClubHeader extends StatelessWidget {
  const ClubHeader({
    Key? key,
    required this.clubOrAgency,
    required this.showProfileAsOther,
    required this.onEditPressed,
    required this.isFollowingOther,
  }) : super(key: key);
  final User clubOrAgency;
  final bool? isFollowingOther;
  final bool showProfileAsOther;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF334D73).withOpacity(0.30),
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClubTopHeader(
                onEditPressed: onEditPressed,
                showEditButton: !showProfileAsOther,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 110 + 18,
                    ),
                    Expanded(
                      child: ReadMoreText(
                        clubOrAgency.bio ?? '',
                        trimLines: 3,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' More',
                        trimExpandedText: 'less',
                        callback: (value) {},
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.87),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFF334D73),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(51, 77, 115, 0.42),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!showProfileAsOther) ...[
          Positioned(
            left: 110,
            bottom: 0,
            child: FollowersHeader(
              followers: 0,
              following: 0,
            ),
          ),
        ],
        if (showProfileAsOther && isFollowingOther != null) ...[
          Positioned(
            left: 110,
            bottom: 0,
            child: VisitFollowersHeader(
              isExpanded: false,
              isFollowing: isFollowingOther!,
              followers: clubOrAgency.followers,
            ),
          ),
        ],
        Positioned(
          left: 18,
          bottom: 6,
          child: ImageProfile(url: clubOrAgency.profilePicture),
        ),
      ],
    );
  }
}
