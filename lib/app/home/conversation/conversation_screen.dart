import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/conversation/conversation_bloc.dart';
import 'package:randolina/app/home/conversation/conversation_search.dart';
import 'package:randolina/app/home/conversation/conversation_tile.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final User currentUser;
  late final ConversationBloc bloc;
  late final Stream<List<Conversation>> conversationStream;
  late final List<Conversation> conversationList;
  @override
  void initState() {
    currentUser = context.read<User>();
    bloc = ConversationBloc(
      database: context.read<Database>(),
      currentUser: currentUser,
    );
    conversationStream = bloc.getConversationsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<List<Conversation>>(
        stream: conversationStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(color: darkBlue),
              actions: [
                if (snapshot.data != null) ...[
                  IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate:
                            ConversationSearch(conversations: snapshot.data!),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      color: darkBlue,
                      size: 30,
                    ),
                  )
                ],
              ],
              title: Text(
                'Messages',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: buildBody(snapshot),
          );
        },
      ),
    );
  }

  Widget buildBody(AsyncSnapshot<List<Conversation>> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      final List<Conversation> items = snapshot.data!;
      if (items.isNotEmpty) {
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(height: 0.5),
          itemBuilder: (context, index) {
            final MiniUser user1 = items[index].user1;
            final MiniUser user2 = items[index].user2;
            final MiniUser otherUser;
            if (user1.id != currentUser.id) {
              otherUser = user1;
            } else {
              otherUser = user2;
            }
            return ConversationTile(
              key: Key(otherUser.profilePicture),
              conversation: items[index],
              currentUser: currentUser,
            );
          },
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: EmptyContent(
            title: 'Aucun message ne suit les personnes pour commencer',
            message: '',
          ),
        );
      }
    } else if (snapshot.hasError) {
      logger.severe(snapshot.error);
      return EmptyContent(
        title: "Quelque chose s'est mal passé",
        message: "Impossible de charger les éléments pour le moment",
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
