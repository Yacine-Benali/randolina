import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/chat/chat_screen.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/message.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/utils.dart';

class UserToChat extends StatefulWidget {
  const UserToChat({
    Key? key,
    required this.otherUser,
  }) : super(key: key);
  final User otherUser;

  @override
  _UserToChatState createState() => _UserToChatState();
}

class _UserToChatState extends State<UserToChat> {
  late final Stream<Conversation?> convStream;
  late final String groupeChatId;
  late final User currentUser;

  Future<bool> checkExist(String groupeChatId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .doc(APIPath.conversationDocument(groupeChatId))
          .get();
      return doc.exists;
    } catch (e) {
      // If any error
      return false;
    }
  }

  @override
  void initState() {
    currentUser = context.read<User>();
    final Database database = context.read<Database>();
    groupeChatId = calculateGroupeChatId(widget.otherUser.id, currentUser.id);

    checkExist(groupeChatId).then((value) {
      if (!value) {
        final Conversation conv = Conversation(
          id: calculateGroupeChatId(currentUser.id, widget.otherUser.id),
          latestMessage: Message(
            id: '',
            type: 0,
            content: '',
            seen: true,
            createdBy: '',
            createdAt: Timestamp.now(),
          ),
          user1: currentUser.toMiniUser(),
          user2: widget.otherUser.toMiniUser(),
          usersIds: [currentUser.id, widget.otherUser.id],
        );

        database.setData(
          path: APIPath.conversationDocument(conv.id),
          data: conv.toMap(),
        );
      }
    });
    //
    convStream = database.streamDocument(
      path: APIPath.conversationDocument(groupeChatId),
      builder: (data, documentId) {
        final data2 = Conversation.fromMap(data, documentId);
        return data2;
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Conversation?>(
      stream: convStream,
      builder: (BuildContext context, AsyncSnapshot<Conversation?> snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          final Conversation conversation = snapshot.data!;

          return ChatScreen(
            conversation: conversation,
            currentUser: currentUser,
            otherUser: widget.otherUser.toMiniUser(),
          );
        } else if (snapshot.hasError) {
          EmptyContent(
            title: '',
            message: snapshot.error.toString(),
          );
        }
        return LoadingScreen(showAppBar: false);
      },
    );
  }
}
