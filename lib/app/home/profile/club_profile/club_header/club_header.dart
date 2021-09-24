import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_top_header.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/followers_header.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/common_widgets/visit_followers_header.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:readmore/readmore.dart';

class ClubHeader extends StatelessWidget {
  const ClubHeader({
    Key? key,
    required this.clubOrAgency,
    required this.showProfileAsOther,
    required this.onEditPressed,
    required this.onMoreInfoPressed,
    required this.isFollowingOther,
    required this.bloc,
    required this.onSavePressed,
  }) : super(key: key);

  final User clubOrAgency;
  final bool? isFollowingOther;
  final bool showProfileAsOther;
  final VoidCallback onEditPressed;
  final VoidCallback onMoreInfoPressed;
  final ProfileBloc bloc;
  final VoidCallback onSavePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ClubTopHeader(
              showProfileAsOther: showProfileAsOther,
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              clubOrAgency: clubOrAgency,
              onMoreInfoPressed: onMoreInfoPressed,
            ),
          ),
        ),
        Container(
          color: backgroundColor,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
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
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 95,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth - 120,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30.0, top: 20),
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
                      ),
                    ],
                  ),
                ),
              ),
              if (!showProfileAsOther) ...[
                Positioned(
                  left: SizeConfig.blockSizeHorizontal * 30,
                  bottom: 0,
                  child: FollowersHeader(
                    followers: 0,
                    following: 0,
                  ),
                ),
              ],
              if (showProfileAsOther && isFollowingOther != null) ...[
                Positioned(
                  left: SizeConfig.blockSizeHorizontal * 30,
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
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ImageProfile(url: clubOrAgency.profilePicture),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
