import 'package:cloud_firestore/cloud_firestore.dart';

class MiniPost {
  MiniPost({
    required this.postId,
    required this.createdAt,
  });

  String postId;
  Timestamp createdAt;

  factory MiniPost.fromMap(Map<String, dynamic> data) {
    final String postId = data['postId'] as String;
    final Timestamp createdAt = data['createdAt'] as Timestamp;

    return MiniPost(
      postId: postId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'createdAt': createdAt,
    };
  }
}
