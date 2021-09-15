import 'package:flutter/material.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/common_widgets/miniuser_to_profile.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    Key? key,
    required this.otherUser,
    required this.appBar,
  }) : super(key: key);
  final AppBar appBar;
  final MiniUser otherUser;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        title: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) => MiniuserToProfile(miniUser: otherUser),
              ),
            );
          },
          leading: ImageProfile(
            url: otherUser.profilePicture,
            height: 35,
            width: 35,
          ),

          title: Text(
            otherUser.name,
            style: TextStyle(color: Colors.black),
          ),
          // subtitle: Text(
          //   otherUser.username,
          //   style: TextStyle(color: Colors.white),
          // ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
