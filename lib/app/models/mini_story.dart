import 'package:cloud_firestore/cloud_firestore.dart';

class MiniStory {
  MiniStory({
    required this.storyId,
    required this.createdAt,
  });

  String storyId;
  Timestamp createdAt;

  factory MiniStory.fromMap(Map<String, dynamic> data) {
    final String storyId = data['storyId'] as String;
    final Timestamp createdAt = data['createdAt'] as Timestamp;

    return MiniStory(
      storyId: storyId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'createdAt': createdAt,
    };
  }
}
