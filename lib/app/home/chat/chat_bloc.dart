import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/message.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ChatBloc {
  ChatBloc({
    required this.currentUser,
    required this.otherUser,
    required this.conversation,
    required this.database,
  });
  final Conversation conversation;
  final User currentUser;
  final MiniUser otherUser;
  final Database database;

  List<Message> messagesList = [];
  BehaviorSubject<List<Message>> messagesListController =
      BehaviorSubject<List<Message>>();

  Stream<List<Message>> get messagesStream => messagesListController.stream;

  void fetchFirstMessages() {
    final Stream<List<Message>> latestMessageStream = database.streamCollection(
      path: APIPath.messagesCollection(conversation.id),
      builder: (data, documentId) => Message.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.orderBy('createdAt', descending: true).limit(20),
    );

    latestMessageStream.listen((latestMessageList) async {
      bool isMessageExist = false;

      //! can this be optimized ?
      if (latestMessageList.isNotEmpty) {
        print('first fetch isNotEmpty');

        if (messagesList.isNotEmpty) {
          for (final Message existingMessage in messagesList) {
            if (existingMessage.id == latestMessageList.elementAt(0).id) {
              isMessageExist = true;
            }
          }
          if (!isMessageExist) {
            messagesList.insert(0, latestMessageList.elementAt(0));
          }
        } else {
          messagesList.insertAll(0, latestMessageList);
        }
        if (!messagesListController.isClosed) {
          print('first fetch');
          messagesListController.sink.add(messagesList);
          if (latestMessageList.elementAt(0).createdBy != currentUser.id &&
              latestMessageList.elementAt(0).seen == false) {
            // logger.info(
            //     'setting ${latestMessageList.elementAt(0).content} to seen true');
            // setLatesttMessageToSeen(latestMessageList.elementAt(0));
          }
        }
      } else {
        final List<Message> emptyList = [];

        messagesListController.sink.add(emptyList);
      }
    });
  }

  Future<bool> fetchNextMessages(Message message) async {
    final List<Message> moreMessages = await database.fetchCollection(
      path: APIPath.messagesCollection(conversation.id),
      builder: (data, documentId) => Message.fromMap(data, documentId),
      queryBuilder: (query) => query
          .orderBy('createdAt', descending: true)
          .startAfter([message.createdAt]).limit(20),
    );
    messagesList.addAll(moreMessages);
    if (!messagesListController.isClosed) {
      messagesListController.sink.add(messagesList);
    }
    return true;
  }

  bool checkMessageSender(Message message) {
    if (message.createdBy == currentUser.id) {
      return true;
    } else {
      return false;
    }
  }

  MiniUser checkUser({required bool isSelf}) {
    final MiniUser miniUser;
    if (isSelf) {
      if (currentUser.id == conversation.user1.id) {
        miniUser = conversation.user1;
      } else {
        miniUser = conversation.user2;
      }
    } else {
      if (currentUser.id == conversation.user1.id) {
        miniUser = conversation.user2;
      } else {
        miniUser = conversation.user1;
      }
    }
    return miniUser;
  }

  Future<void> sendMessage(String content, int type) async {
    final Message message = Message(
      id: '',
      type: type,
      content: content,
      seen: false,
      createdBy: currentUser.id,
      createdFor: otherUser.id,
      createdAt: Timestamp.now(),
    );

    database.addDocument(
      path: APIPath.messagesCollection(conversation.id),
      data: message.toMap(),
    );

    database.updateData(
      path: APIPath.conversationDocument(conversation.id),
      data: {'latestMessage': message.toMap()},
    );
  }

  Future<bool> sendImageMessage(File file, int type) async {
    final Uuid uuid = Uuid();

    final String downloadUrl = await database.uploadFile(
      path: APIPath.chatPhotosFile(conversation.id, uuid.v4()),
      filePath: file.path,
    );

    await sendMessage(downloadUrl, 1);
    return true;
  }

  void setLatesttMessageToSeen(Message message) {
    message.seen = true;
    logger.info('setting ${message.content} to true');
    database.updateData(
      path: APIPath.conversationDocument(conversation.id),
      data: {'latestMessage': message.toMap()},
    );
  }

  void dispose() {
    // print('bloc stream diposed called');
    messagesListController.close();
  }
}
