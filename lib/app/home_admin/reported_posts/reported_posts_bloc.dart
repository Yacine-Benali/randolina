import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:rxdart/rxdart.dart';

class ReportedPostsBloc {
  ReportedPostsBloc({required this.database});
  final Database database;

  List<String> postsIds = [];
  List<Post> postsList = [];
  BehaviorSubject<List<Post>> postsListController =
      BehaviorSubject<List<Post>>();

  Stream<List<Post>> get postsStream => postsListController.stream;
  int index = 0;

  Future<void> getPostsIds() async {
    final List<String>? data = await database.fetchDocument(
      path: APIPath.reportedPostsDocument(),
      builder: (data, id) => (data['reportedPosts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

    if (data != null) postsIds = data;
  }

  Future<void> startFresh() async {
    index = 0;
    postsList.clear();
    postsIds.clear();
    await fetch10Posts();
  }

  Future<bool> fetch10Posts() async {
    if (postsIds.isEmpty) await getPostsIds();
    if (postsIds.isEmpty && !postsListController.isClosed) {
      postsListController.sink.add([]);
      return true;
    }
    final List<String> postIdsSublit = [];

    if (index == postsIds.length) {
      return true;
    } else if ((postsIds.length - index) < 10) {
      for (int i = index; i < postsIds.length; i++) {
        postIdsSublit.add(postsIds.elementAt(i));
        index++;
      }
    } else {
      postIdsSublit.addAll(postsIds.sublist(index, index + 10));
      index += 10;
    }

    final List<Post> morePosts = await database.fetchCollection(
      path: APIPath.postsCollection(),
      queryBuilder: (query) => query.where(
        FieldPath.documentId,
        whereIn: postIdsSublit,
      ),
      builder: (data, documentId) => Post.fromMap(data, documentId),
    );

    postsList.addAll(morePosts);
    if (!postsListController.isClosed) {
      postsListController.sink.add(postsList);
    }
    return true;
  }
}
