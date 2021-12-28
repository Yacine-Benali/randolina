import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_user.dart';

class Post {
  Post({
    required this.id,
    required this.type,
    required this.description,
    required this.content,
    required this.contentPath,
    required this.createdAt,
    required this.numberOfLikes,
    required this.miniUser,
  });
  final String id;
  final int type;
  final String description;
  final List<String> content;
  final List<String> contentPath;
  final Timestamp createdAt;
  final int numberOfLikes;
  final MiniUser miniUser;

  factory Post.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final int type = data['type'] as int;
    final String description = data['description'] as String;
    final List<String> content =
        (data['content'] as List<dynamic>).map((e) => e as String).toList();
    final List<String> contentPath =  
        (data['contentPath'] as List<dynamic>).map((e) => e as String).toList();

    final Timestamp createdAt = data['createdAt'] as Timestamp;
    final int numberOfLikes = data['numberOfLikes'] as int;
    final MiniUser miniUser =
        MiniUser.fromMap(data['miniUser'] as Map<String, dynamic>);
    return Post(
      id: id,
      type: type,
      description: description,
      content: content,
      contentPath: contentPath,
      createdAt: createdAt,
      numberOfLikes: numberOfLikes,
      miniUser: miniUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'content': content,
      'contentPath': contentPath,
      'createdAt': createdAt,
      'numberOfLikes': numberOfLikes,
      'miniUser': miniUser.toMap(),
    };
  }
}
