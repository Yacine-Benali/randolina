import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/chat/chat_screen.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/utils/logger.dart';

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
      logger.info(
          'message: ${widget.conversation.latestMessage.content}=> ${widget.conversation.latestMessage.seen}');
    } else {
      notification = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: otherUser.profilePicture,
          imageBuilder: (context, imageProvider) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(47),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF334D73).withOpacity(0.43),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        title: Text(
          otherUser.name,
          style: notification
              ? TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                )
              : TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
        ),
        subtitle: widget.conversation.latestMessage.type == 0
            ? Text(widget.conversation.latestMessage.content)
            : Text('image'),
        trailing: notification
            ? Container(
                width: SizeConfig.blockSizeHorizontal * 4,
                height: SizeConfig.blockSizeVertical * 1.87,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            : SizedBox(
                // width: SizeConfig.safeBlockHorizontal * 4,
                // height: SizeConfig.safeBlockVertical * 1.87,
                ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                key: Key(otherUser.id),
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
