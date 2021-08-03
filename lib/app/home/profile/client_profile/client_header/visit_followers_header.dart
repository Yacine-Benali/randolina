import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_bloc.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';

class VisitFollowersHeader extends StatefulWidget {
  const VisitFollowersHeader({
    Key? key,
    required this.isExpanded,
    required this.followers,
    required this.isFollowing,
  }) : super(key: key);

  final bool isExpanded;
  final bool isFollowing;
  final int followers;

  @override
  _VisitFollowersHeaderState createState() => _VisitFollowersHeaderState();
}

class _VisitFollowersHeaderState extends State<VisitFollowersHeader> {
  late bool isFollowing;
  late ClientProfileBloc bloc;

  @override
  void initState() {
    bloc = context.read<ClientProfileBloc>();
    isFollowing = widget.isFollowing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: widget.isExpanded ? 0 + 20 : 10 + 20,
      child: Row(
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
              color: isFollowing ? Colors.grey : null,
              buttonText: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Follow'),
                  // todo @average change the icons to the ones in the design
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.add),
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
              minHeight: 26,
              minWidth: 120,
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
      ),
    );
  }
}
