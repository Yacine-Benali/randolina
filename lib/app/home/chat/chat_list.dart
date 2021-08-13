import 'package:flutter/material.dart';
import 'package:randolina/app/home/chat/chat_bloc.dart';
import 'package:randolina/app/home/chat/message_tile.dart';
import 'package:randolina/app/models/message.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/common_widgets/empty_content.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.bloc}) : super(key: key);
  final ChatBloc bloc;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Stream<List<Message>>? messagesStream;
  final ScrollController listScrollController = ScrollController();
  late List<Message> messages;
  bool isSelf = false;
  late bool isLoadingNextMessages;

  @override
  void initState() {
    messagesStream = widget.bloc.messagesStream;
    isLoadingNextMessages = false;
    widget.bloc.fetchFirstMessages();

    listScrollController.addListener(() {
      final double maxScroll = listScrollController.position.maxScrollExtent;
      final double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (messages.isNotEmpty) {
          setState(() {
            isLoadingNextMessages = true;
          });
          widget.bloc.fetchNextMessages(messages.last).then((value) {
            setState(() {
              isLoadingNextMessages = false;
            });
          });
        }
      }
    });

    super.initState();
  }

  /// show progress indicator when user upload old messages
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoadingNextMessages ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            messages = snapshot.data!;
            if (messages.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    // oups u have reached the top of messages list
                    return _buildProgressIndicator();
                  } else {
                    isSelf = widget.bloc.checkMessageSender(messages[index]);
                    final MiniUser miniUser =
                        widget.bloc.checkUser(isSelf: isSelf);
                    bool showAvatar = false;
                    //
                    if (index == 0) {
                      showAvatar = true;
                    } else if (messages[index].createdBy !=
                        messages[index - 1].createdBy) {
                      //
                      showAvatar = true;
                    }

                    return MessageTile(
                      message: messages[index],
                      isSelf: isSelf,
                      avatarUrl: showAvatar ? miniUser.profilePicture : null,
                    );
                  }
                },
                // +1 to include the loading widget
                itemCount: messages.length + 1,
                reverse: true,
                controller: listScrollController,
              );
            } else {
              return EmptyContent(
                title: '',
                message:
                    'here you can send and recieve message from the teachers',
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: "Can't load items right now",
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  void dispose() {
    //print('disposed called');
    //bloc.dispose();
    listScrollController.dispose();
    super.dispose();
  }
}
