import 'package:randolina/app/models/message.dart';
import 'package:randolina/app/models/mini_user.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.latestMessage,
    required this.user1,
    required this.user2,
    required this.usersIds,
  });

  final String id;
  final Message latestMessage;
  final MiniUser user1;
  final MiniUser user2;
  final List<String> usersIds;

  factory Conversation.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final Message latestMessage = Message.fromMap(
        data['latestMessage'] as Map<String, dynamic>, documentId);

    final List<String> usersIds =
        (data['usersIds'] as List<dynamic>).map((e) => e as String).toList();

    final MiniUser user1 =
        MiniUser.fromMap(data['user1'] as Map<String, dynamic>);
    final MiniUser user2 =
        MiniUser.fromMap(data['user2'] as Map<String, dynamic>);

    return Conversation(
      id: id,
      latestMessage: latestMessage,
      user1: user1,
      user2: user2,
      usersIds: usersIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latestMessage': latestMessage.toMap(),
      'user1': user1.toMap(),
      'user2': user2.toMap(),
      'usersIds': usersIds,
    };
  }
}
