import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/user.dart';

class FollowersHeader extends StatelessWidget {
  const FollowersHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();

    return Positioned(
      left: 110,
      bottom: 0,
      child: Container(
        width: 103,
        height: 31,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(51, 77, 115, 0.38),
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(51, 77, 115, 0.42),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: user.followers.toString(),
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
      ),
    );
  }
}
