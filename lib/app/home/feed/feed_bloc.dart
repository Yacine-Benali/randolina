import 'package:randolina/app/models/mini_post.dart';
import 'package:randolina/app/models/mini_story.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/story.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/app/models/user_followers_posts.dart';
import 'package:randolina/app/models/user_followers_stories.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc {
  FeedBloc({
    required this.database,
    required this.currentUser,
  });
  final Database database;
  final User currentUser;

  List<String> postsIds = [];
  List<UserFollowersStories> storiesList = [];

  List<Post> postsList = [];
  BehaviorSubject<List<Post>> postsListController =
      BehaviorSubject<List<Post>>();

  Stream<List<Post>> get postsStream => postsListController.stream;

  int index = 0;

  Future<void> getPostsIds() async {
    final List<UserFollowersPosts> data = await database.fetchCollection(
        path: APIPath.userFollowerPostsCollection(),
        queryBuilder: (query) =>
            query.where('followers', arrayContains: currentUser.id),
        builder: (data, documentId) =>
            UserFollowersPosts.fromMap(data, documentId));

    final List<List<MiniPost>> data2 = data.map((e) {
      // logger.info(e.userId);
      // logger.info(e.postsIds);
      return e.postsIds;
    }).toList();

    final List<MiniPost> data3 = data2.expand((element) => element).toList();

    postsIds = data3.map((e) => e.postId).toList();
  }

  Future<List<UserFollowersStories>> getStoriesIdsAndUsers() async {
    final List<UserFollowersStories> data = await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) =>
          query.where('followers', arrayContains: currentUser.id),
      builder: (data, documentId) =>
          UserFollowersStories.fromMap(data, documentId),
    );
    storiesList = data;

    return data;
  }

  bool haveStories(MiniUser miniUser) {
    final UserFollowersStories data2 =
        storiesList.firstWhere((element) => element.miniUser.id == miniUser.id);
    if (data2.storiesIds.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<Story?> getStory(MiniStory miniStory) {
    return database.fetchDocument(
      path: APIPath.storyDocument(miniStory.storyId),
      builder: (data, documentId) => Story.fromMap(data, documentId),
    );
  }

  Future<bool> fetch10Posts() async {
    if (postsIds.isEmpty) {
      await getPostsIds();
    }
    if (postsIds.isEmpty) {
      if (!postsListController.isClosed) {
        postsListController.sink.add([]);
      }
    }
    final List<String> postIdsSublit = [];

    // logger.info('postsIds: ${postsIds.length}\t index: $index');
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
        'id',
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
