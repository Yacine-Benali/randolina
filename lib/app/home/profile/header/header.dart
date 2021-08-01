import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/header/header_bottom_part/description.dart';
import 'package:randolina/app/home/profile/header/header_bottom_part/followers_header.dart';
import 'package:randolina/app/home/profile/header/header_top_part/header_top_part.dart';
import 'package:randolina/app/home/profile/header/image_profile.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
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
              HeaderTopPart(),
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
        ImageProfileHeader(isExpanded: isExpanded),
      ],
    );
  }
}
