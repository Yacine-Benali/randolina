import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/message.dart';
import 'package:randolina/app/models/user.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  ChatBloc({
    required this.currentUser,
    required this.conversation,
  });
  final Conversation conversation;
  final User currentUser;

  List<Message> messagesList = [];
  List<Message> emptyList = [];
  BehaviorSubject<List<Message>> messagesListController =
      BehaviorSubject<List<Message>>();

  Stream<List<Message>> get messagesStream => messagesListController.stream;

  // void fetchFirstMessages() {
  //   Stream<List<Message>> latestMessageStream =
  //       provider.latestMessagesStream(
  //     student.schoolName,
  //     conversation.groupChatId,
  //   );
  //   latestMessageStream.listen((latestMessageList) async {
  //     bool isMessageExist = false;
  //     //! can this be optimized ?
  //     if (latestMessageList.isNotEmpty) {
  //       if (messagesList.isNotEmpty) {
  //         for (Message existingMessage in messagesList) {
  //           if (existingMessage.uid == latestMessageList.elementAt(0).uid)
  //             isMessageExist = true;
  //         }
  //         if (!isMessageExist) {
  //           messagesList.insert(0, latestMessageList.elementAt(0));
  //         }
  //       } else {
  //         messagesList.insertAll(0, latestMessageList);
  //       }
  //       if (!messagesListController.isClosed) {
  //         //print('first fetch');
  //         messagesListController.sink.add(messagesList);
  //         if (latestMessageList.elementAt(0).senderId != student.uid &&
  //             latestMessageList.elementAt(0).seen == false) {
  //           setLatesttMessageToSeen(latestMessageList.elementAt(0));
  //         }
  //       }
  //     } else {
  //       messagesListController.sink.add(emptyList);
  //     }
  //   });
  // }

  // Future<bool> fetchNextMessages(Message message) async {
  //   List<Message> moreMessages = await provider.fetchMessages(
  //     student.schoolName,
  //     conversation.groupChatId,
  //     message,
  //     20,
  //   );
  //   messagesList.addAll(moreMessages);
  //   if (!messagesListController.isClosed) {
  //     messagesListController.sink.add(messagesList);
  //   }
  //   return true;
  // }

  // bool checkMessageSender(Message message) {
  //   if (message.senderId == student.uid) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<void> sendMessage(String content, int type) async {
  //   int timestamp = DateTime.now().millisecondsSinceEpoch;
  //   Message message = Message(
  //     uid: timestamp.toString(),
  //     content: content,
  //     type: type,
  //     receiverId: conversation.teacher['uid'],
  //     seen: false,
  //     senderId: conversation.student['uid'],
  //     timestamp: timestamp,
  //   );
  //   provider.addMessageToCollection(
  //     student.schoolName,
  //     conversation.groupChatId,
  //     message,
  //   );
  //   provider.updateLatestMessage(
  //     student.schoolName,
  //     conversation.groupChatId,
  //     message,
  //   );
  // }

  // Future<bool> sendImageMessage(File file, int type) async {
  //   String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   var result = await provider.uploadImage(
  //       student.schoolName, conversation.groupChatId, file, timestamp);

  //   if (result != null) {
  //     String downloadUrl = result.toString();
  //     sendMessage(downloadUrl, 1);
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // void setLatesttMessageToSeen(Message message) {
  //   message.seen = true;
  //   provider.updateLatestMessage(
  //     student.schoolName,
  //     conversation.groupChatId,
  //     message,
  //   );
  // }

  // void dispose() {
  //   // print('bloc stream diposed called');
  //   messagesListController.close();
  // }
}
