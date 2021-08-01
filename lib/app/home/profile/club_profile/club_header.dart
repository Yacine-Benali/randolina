import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/club_profile/widgets/icon_header.dart';
import 'package:randolina/app/home/profile/club_profile/widgets/image_profile.dart';
import 'package:randolina/app/home/profile/club_profile/widgets/name_location.dart';
import 'package:randolina/app/home/profile/club_profile/widgets/num_follower.dart';

class HeaderAgence extends StatelessWidget {
  const HeaderAgence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 215,
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
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NameLocationClub(),
                    IconHeader(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 142),
                width: 265,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.only(top: 16, right: 22),
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
                        padding: const EdgeInsets.all(8.8),
                        child: Image.asset(
                          'assets/icons/Vector 7.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ImageProfile(),
        NumFollowers(),
      ],
    );
  }
}
