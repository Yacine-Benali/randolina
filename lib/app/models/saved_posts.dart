import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/utils/logger.dart';

class SavedPosts {
  SavedPosts({required this.list});
  final List<SavedPost> list;

  factory SavedPosts.fromMap(Map<String, dynamic> data) {
    final List<String> postsId =
        (data['postsId'] as List<dynamic>).map((e) => e as String).toList();

    final List<Timestamp> savedAt =
        (data['savedAt'] as List<dynamic>).map((e) => e as Timestamp).toList();

    if (postsId.length != savedAt.length) {
      logger.severe('SavedPosts Problem (savedAt.length != postsId.length)');
      throw Exception('Unable to get saved posts');
    }

    final List<SavedPost> list = [];
    for (var i = 0; i < postsId.length; i++) {
      list.add(
        SavedPost(
          postId: postsId.elementAt(i),
          savedAt: savedAt.elementAt(i),
        ),
      );
    }

    return SavedPosts(
      list: list,
    );
  }
}

class SavedPost {
  SavedPost({
    required this.postId,
    required this.savedAt,
  });

  final String postId;
  final Timestamp savedAt;
}
