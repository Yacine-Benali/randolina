import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  Story({
    required this.type,
    required this.createdBy,
    required this.createdAt,
    required this.content,
    required this.contentPath,
  });
  int type;
  String createdBy;
  Timestamp createdAt;
  String content;
  String contentPath;

  // ignore: avoid_unused_constructor_parameters
  factory Story.fromMap(Map<String, dynamic> data, String documentId) {
    final int type = data['type'] as int;
    final String createdBy = data['createdBy'] as String;
    final Timestamp createdAt = data['createdAt'] as Timestamp;
    final String content = data['content'] as String;
    final String contentPath = data['contentPath'] as String;

    return Story(
      type: type,
      createdBy: createdBy,
      createdAt: createdAt,
      content: content,
      contentPath: contentPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'content': content,
      'contentPath': contentPath,
    };
  }
}
