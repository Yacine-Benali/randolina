import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/conversation/conversation_tile.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/constants/app_colors.dart';

class ConversationSearch extends SearchDelegate<String> {
  ConversationSearch({required this.conversations});
  final List<Conversation> conversations;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, 'value');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildResult(context);
  @override
  Widget buildSuggestions(BuildContext context) => buildResult(context);

  Widget buildResult(BuildContext context) {
    final User currentUser = context.read<User>();

    final List<Conversation> relevant = conversations.where((conversation) {
      final MiniUser otherUser;

      if (currentUser.id == conversation.user1.id) {
        otherUser = conversation.user2;
      } else {
        otherUser = conversation.user1;
      }
      if (otherUser.name.toLowerCase().contains(query.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();

    return Container(
      color: backgroundColor,
      child: ListView.separated(
        itemCount: relevant.length,
        separatorBuilder: (context, index) => Divider(height: 0.5),
        itemBuilder: (context, index) {
          //return Container();
          return ConversationTile(
            key: Key(relevant[index].id),
            conversation: relevant[index],
            currentUser: currentUser,
          );
        },
      ),
    );
  }
}
