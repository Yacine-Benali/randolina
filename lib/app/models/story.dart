import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  Story({
    required this.type,
    required this.createdBy,
    required this.createdAt,
    required this.content,
  });
  int type;
  String createdBy;
  Timestamp createdAt;
  String content;
}
