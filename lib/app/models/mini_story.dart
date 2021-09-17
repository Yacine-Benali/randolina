import 'package:cloud_firestore/cloud_firestore.dart';

class MiniStory {
  MiniStory({
    required this.storyId,
    required this.createdAt,
    required this.type,
  });

  String storyId;
  Timestamp createdAt;
  int type;

  factory MiniStory.fromMap(Map<String, dynamic> data) {
    final String storyId = data['storyId'] as String;
    final Timestamp createdAt = data['createdAt'] as Timestamp;
    final int type = data['type'] as int;

    return MiniStory(
      storyId: storyId,
      createdAt: createdAt,
      type: type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'createdAt': createdAt,
      'type': type,
    };
  }
}
