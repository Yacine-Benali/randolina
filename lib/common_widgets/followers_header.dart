import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/size_config.dart';

// ignore: must_be_immutable
class FollowersHeader extends StatelessWidget {
  FollowersHeader({
    required this.following,
    required this.followers,
  });

  final int following;
  final int followers;

  // ignore: avoid_field_initializers_in_const_classes
  final double width = SizeConfig.blockSizeHorizontal * 29;
  // ignore: avoid_field_initializers_in_const_classes
  final double height = SizeConfig.blockSizeVertical * 3.5;
  // ignore: avoid_field_initializers_in_const_classes
  final double middleWidth = SizeConfig.blockSizeHorizontal * 2;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: Color.fromRGBO(51, 77, 115, 0.38),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF334D73).withOpacity(0.42),
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '$following',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' Following',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: middleWidth),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: Color.fromRGBO(51, 77, 115, 0.38),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF334D73).withOpacity(0.42),
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '$followers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' Followers',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
