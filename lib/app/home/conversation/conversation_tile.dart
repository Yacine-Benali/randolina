import 'package:flutter/material.dart';
import 'package:randolina/app/home/chat/chat_screen.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/common_widgets/size_config.dart';

class ConversationTile extends StatefulWidget {
  const ConversationTile({
    Key? key,
    required this.conversation,
    required this.currentUser,
  }) : super(key: key);

  final Conversation conversation;
  final User currentUser;

  @override
  _ConversationTileState createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  late final MiniUser otherUser;
  late bool notification;
  @override
  void initState() {
    final MiniUser user1 = widget.conversation.user1;
    final MiniUser user2 = widget.conversation.user2;

    if (user1.id != widget.currentUser.id) {
      otherUser = user1;
    } else {
      otherUser = user2;
    }

    if (widget.conversation.latestMessage.createdBy != widget.currentUser.id) {
      notification = !widget.conversation.latestMessage.seen;
    }
    notification = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: ImageProfile(
          url: otherUser.profilePicture,
          height: 60,
          width: 60,
        ),
        title: Text(
          otherUser.name,
          style: notification
              ? TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                )
              : TextStyle(color: Colors.black),
        ),
        subtitle: Text(widget.conversation.latestMessage.content),
        trailing: notification
            ? Container(
                width: SizeConfig.safeBlockHorizontal * 4,
                height: SizeConfig.safeBlockVertical * 1.87,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            : Container(
                width: SizeConfig.safeBlockHorizontal * 4,
                height: SizeConfig.safeBlockVertical * 1.87,
              ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversation: widget.conversation,
                currentUser: widget.currentUser,
                otherUser: otherUser,
              ),
            ),
          );
        },
      ),
    );
  }
}
