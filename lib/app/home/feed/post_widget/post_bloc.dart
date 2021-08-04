import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

class PostBloc {
  PostBloc({
    required this.currentUser,
    required this.database,
  });
  final User currentUser;
  final Database database;

  Future<bool> isLiked(Post post) async {
    final List<String> list = await database.fetchCollection(
      path: APIPath.likesCollection(post.id),
      queryBuilder: (query) =>
          query.where('likedBy', arrayContains: currentUser.id),
      builder: (data, id) => id,
    );

    return list.isNotEmpty;
  }

  Future<void> like(Post post) async => FirebaseFunctions.instance
      .httpsCallable('likePost')
      .call({'postId': post.id});

  Future<void> unlike(Post post) async {
    // todo @low for security purposes call a function here
    final List<String> list = await database.fetchCollection(
      path: APIPath.likesCollection(post.id),
      queryBuilder: (query) =>
          query.where('likedBy', arrayContains: currentUser.id),
      builder: (data, id) => id,
    );

    if (list.isNotEmpty) {
      await database
          .updateData(path: APIPath.likesDocument(post.id, list[0]), data: {
        'likedBy': FieldValue.arrayRemove([currentUser.id]),
        'length': FieldValue.increment(-1),
      });
      await database.updateData(path: APIPath.postDocument(post.id), data: {
        'numberOfLikes': FieldValue.increment(-1),
      });
    }
  }
}
