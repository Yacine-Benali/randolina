import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/chat/chat_app_bar.dart';
import 'package:randolina/app/home/chat/chat_bloc.dart';
import 'package:randolina/app/home/chat/chat_input_bar.dart';
import 'package:randolina/app/home/chat/chat_list.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.conversation,
    required this.currentUser,
    required this.otherUser,
  });
  final Conversation conversation;
  final User currentUser;
  final MiniUser otherUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatBloc chatBloc;

  @override
  void initState() {
    chatBloc = ChatBloc(
      currentUser: widget.currentUser,
      conversation: widget.conversation,
      database: context.read<Database>(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ChatAppBar(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        otherUser: widget.otherUser,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChatList(bloc: chatBloc),
          ),
          ChatInputBar(bloc: chatBloc),
        ],
      ),
    );
  }
}
