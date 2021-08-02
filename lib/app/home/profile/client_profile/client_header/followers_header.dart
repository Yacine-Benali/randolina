import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FollowersHeader extends StatelessWidget {
  const FollowersHeader({
    required this.isExpanded,
    required this.following,
    required this.followers,
  });

  final bool isExpanded;
  final int following;
  final int followers;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: isExpanded ? 0 + 20 : 10 + 20,
      child: Row(
        children: [
          Container(
            width: 120,
            height: 26,
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
          Container(
            width: 120,
            height: 26,
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
      ),
    );
  }
}
