import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/followers_header.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/image_profile.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/name_location.dart';
import 'package:randolina/app/models/user.dart';
import 'package:readmore/readmore.dart';

class ClubHeader extends StatelessWidget {
  const ClubHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 220,
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
              NameLocationClub(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 110 + 18,
                    height: 110,
                  ),
                  Expanded(
                    child: ReadMoreText(
                      user.bio ?? '',
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
                    margin: const EdgeInsets.only(top: 0, right: 30),
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
            ],
          ),
        ),
        FollowersHeader(),
        ImageProfile(),
      ],
    );
  }
}
