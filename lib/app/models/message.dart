import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.id,
    required this.type,
    required this.content,
    required this.seen,
    required this.createdBy,
    required this.createdAt,
  });
  final String id;
  final int type;
  final String content;
  final bool seen;
  final String createdBy;
  final Timestamp createdAt;

  factory Message.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final int type = data['type'] as int;
    final String content = data['content'] as String;
    final bool seen = data['seen'] as bool;
    final String createdBy = data['createdBy'] as String;
    final Timestamp createdAt = data['createdAt'] as Timestamp;

    return Message(
      id: id,
      type: type,
      content: content,
      seen: seen,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'content': content,
      'seen': seen,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    print('message content: $content  timestamp: $createdAt ');
    return super.toString();
  }
}
