import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/chat/chat_screen.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/utils.dart';

class ClientToChat extends StatelessWidget {
  const ClientToChat({
    Key? key,
    required this.client,
  }) : super(key: key);
  final Client client;

  @override
  Widget build(BuildContext context) {
    final Database database = context.read<Database>();
    final User currentUser = context.read<User>();
    final String groupeChatId =
        calculateGroupeChatId(client.id, currentUser.id);

    return FutureBuilder<Conversation?>(
      future: database.fetchDocument(
        path: APIPath.conversationDocument(groupeChatId),
        builder: (data, documentId) {
          final data2 = Conversation.fromMap(data, documentId);
          return data2;
        },
      ),
      builder: (BuildContext context, AsyncSnapshot<Conversation?> snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          final Conversation conversation = snapshot.data!;
          final MiniUser otherUser;

          if (currentUser.id == conversation.user1.id) {
            otherUser = conversation.user2;
          } else {
            otherUser = conversation.user1;
          }
          return ChatScreen(
            conversation: conversation,
            currentUser: currentUser,
            otherUser: otherUser,
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
