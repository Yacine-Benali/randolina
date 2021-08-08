import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/common_widgets/size_config.dart';

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
        title: ListTile(
          leading: Material(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: otherUser.profilePicture == ''
                ? CircleAvatar(
                    radius: SizeConfig.blockSizeHorizontal * 4,
                    backgroundColor: Colors.white,
                    child: Text(
                      otherUser.name,
                      style: TextStyle(color: Colors.indigo),
                    ),
                  )
                : CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: SizeConfig.safeBlockHorizontal * 8.5,
                      height: SizeConfig.safeBlockHorizontal * 8.5,
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                    ),
                    imageUrl: otherUser.profilePicture,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
          ),
          title: Text(
            otherUser.name,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            otherUser.username,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
