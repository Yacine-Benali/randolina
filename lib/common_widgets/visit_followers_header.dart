import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/constants/app_colors.dart';

//todo make this widget common between client and others
class VisitFollowersHeader extends StatefulWidget {
  const VisitFollowersHeader({
    Key? key,
    required this.isExpanded,
    required this.followers,
    required this.isFollowing,
    required this.bloc,
  }) : super(key: key);

  final bool isExpanded;
  final bool isFollowing;
  final int followers;
  final ProfileBloc bloc;

  @override
  _VisitFollowersHeaderState createState() => _VisitFollowersHeaderState();
}

class _VisitFollowersHeaderState extends State<VisitFollowersHeader> {
  late bool isFollowing;
  late ProfileBloc bloc;

  @override
  void initState() {
    bloc = widget.bloc;
    isFollowing = widget.isFollowing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120,
          height: 26,
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF334D73).withOpacity(0.42),
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CustomElevatedButton(
            // todo @low fix witth to be same as ui design and color
            minHeight: 26,
            minWidth: 120,
            color: isFollowing ? Colors.blueGrey[200] : null,

            buttonText: isFollowing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Follow', style: TextStyle(color: darkBlue)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: Image.asset(
                              'assets/icons_final/user_already_followed.png'),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Follow'),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: Image.asset(
                              'assets/icons_final/user_not_followed.png'),
                        ),
                      )
                    ],
                  ),
            onPressed: () {
              if (isFollowing) {
                isFollowing = false;
                // unfollow
                bloc.unfollowOtherUser();
              } else {
                isFollowing = true;
                // follow
                bloc.followOtherUser();
              }

              setState(() {});
            },
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
                    text: '${widget.followers}',
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
