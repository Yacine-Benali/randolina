import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

class ConversationBloc {
  ConversationBloc({
    required this.database,
    required this.currentUser,
  });
  final Database database;
  final User currentUser;

  Stream<List<Conversation>> getConversationsStream() {
    return database.streamCollection(
      path: APIPath.conversationsCollection(),
      builder: (data, documentId) => Conversation.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.orderBy('latestMessage.seen', descending: false),
    );
  }
}
