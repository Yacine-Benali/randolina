import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/conversation/conversation_bloc.dart';
import 'package:randolina/app/home/conversation/conversation_tile.dart';
import 'package:randolina/app/models/conversation.dart';
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Messages',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Material(
        child: StreamBuilder<List<Conversation>>(
          stream: conversationStream,
          builder: (context, snapshot) {
            logger.info(snapshot);
            if (snapshot.hasData && snapshot.data != null) {
              final List<Conversation> items = snapshot.data!;
              if (items.isNotEmpty) {
                return _buildList(items);
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EmptyContent(
                    title: 'No Messages follow people to get started',
                    message: '',
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: "Can't load items right now",
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Conversation> items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        //return Container();
        return ConversationTile(
          conversation: items[index],
          currentUser: currentUser,
        );
      },
    );
  }
}
