import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_user.dart';

class Comment {
  Comment({
    required this.miniUser,
    required this.content,
    required this.createdAt,
  });

  final MiniUser miniUser;
  final String content;
  final Timestamp createdAt;

  factory Comment.fromMap(Map<String, dynamic> data) {
    final MiniUser miniUser =
        MiniUser.fromMap(data['miniUser'] as Map<String, dynamic>);
    final String content = data['content'] as String;
    final Timestamp createdAt =
        (data['createdAt'] as Timestamp?) ?? Timestamp.now();

    return Comment(
      miniUser: miniUser,
      content: content,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'miniUser': miniUser.toMap(),
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
