import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  FeedBloc({
    required this.database,
    required this.currentUser,
  });
  final Database database;
  final User currentUser;

  List<String> postsIds = [];

  List<Post> postsList = [];
  BehaviorSubject<List<Post>> postsListController =
      BehaviorSubject<List<Post>>();

  Stream<List<Post>> get postsStream => postsListController.stream;

  int index = 0;

  Future<void> getPostsIds() async {
    final List<List<Map<String, dynamic>>> data =
        await database.fetchCollection(
      path: APIPath.userFollowerPostsCollection(),
      queryBuilder: (query) =>
          query.where('followers', arrayContains: currentUser.id),
      builder: (data, documentId) => (data['postsIds'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

    final List<Map<String, dynamic>> data2 =
        data.expand((element) => element).toList();

    postsIds = data2.map((e) => e['postId'] as String).toList();

    //  logger.info('there are a total of ' + postsIds.length.toString() + 'posts');
  }

  void fetchFirstPosts() {}

  Future<bool> fetch10Posts() async {
    if (postsIds.isEmpty) {
      await getPostsIds();
    }
    final List<String> postIdsSublit = [];

    logger.info('postsIds: ${postsIds.length}\t index: $index');
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
    logger.info('postIdsSublit: ${postIdsSublit.length}\t index: $index');

    final List<Post> morePosts = await database.fetchCollection(
      path: APIPath.postsCollection(),
      queryBuilder: (query) => query.where(
        'id',
        whereIn: postIdsSublit,
      ),
      builder: (data, documentId) => Post.fromMap(data, documentId),
    );

    postsList.addAll(morePosts);
    if (!postsListController.isClosed) {
      postsListController.sink.add(postsList);
    } else {}
    return true;
  }
}
