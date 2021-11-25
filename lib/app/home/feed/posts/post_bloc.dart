import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:randolina/app/models/comment.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/saved_posts.dart';
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

  Future<void> deletePost(Post post) async {
    await database.deleteDocument(path: APIPath.postDocument(post.id));
    // TODO @average call a CF here, delete storage media
    await database.updateData(
        path: APIPath.userFollowerPostsDocument(currentUser.id),
        data: {
          'postsIds': FieldValue.arrayRemove([
            {
              'postId': post.id,
              'createdAt': post.createdAt,
            }
          ]),
        });
    await database.setData(
      path: APIPath.reportedPostsDocument(),
      data: {
        'reportedPosts': FieldValue.arrayRemove([post.id])
      },
    );
  }

  Future<bool> isLiked(Post post) async {
    // TODO @low decrease usage by downloading this doc once and then check it
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
    // TODO @low for security purposes call a function here
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

  Future<void> publishComment(Post post, String content) async {
    final comment = Comment(
      miniUser: currentUser.toMiniUser(),
      content: content,
      createdAt: Timestamp.now(),
    );

    await database.addDocument(
      path: APIPath.commentsCollection(post.id),
      data: comment.toMap(),
    );
  }

  Future<void> savePost(Post post) async {
    await database.setData(
      path: APIPath.savedPostsDocument(currentUser.id),
      data: {
        'postsId': FieldValue.arrayUnion([post.id]),
        'savedAt': FieldValue.arrayUnion([Timestamp.now()])
      },
    );
  }

  Future<SavedPost?> isSaved(Post post) async {
    final List<SavedPosts> list = await database.fetchCollection(
      path: APIPath.savedPostsCollection(currentUser.id),
      queryBuilder: (query) => query.where('postsId', arrayContains: post.id),
      builder: (data, id) => SavedPosts.fromMap(data),
    );

    final SavedPost theSavedPost = list
        .map((e) => e.list)
        .toList()
        .expand((e) => e)
        .toList()
        .firstWhere((e) => e.postId == post.id,
            orElse: () => SavedPost(postId: 'null', savedAt: Timestamp.now()));

    if (theSavedPost.postId == 'null') {
      return null;
    } else {
      return theSavedPost;
    }
  }

  Future<void> unsavePost(SavedPost savedPost) async {
    await database.setData(
      path: APIPath.savedPostsDocument(currentUser.id),
      data: {
        'postsId': FieldValue.arrayRemove([savedPost.postId]),
        'savedAt': FieldValue.arrayRemove([savedPost.savedAt])
      },
    );
  }

  Future<void> reportPost(Post post) async {
    database.setData(
      path: APIPath.reportedPostsDocument(),
      data: {
        'reportedPosts': FieldValue.arrayUnion([post.id])
      },
    );
  }
}
