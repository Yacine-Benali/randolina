import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<UserFollowersStories> storiesList = [];

  List<String> postsIds = [];
  List<Post> postsList = [];
  BehaviorSubject<List<Post>> postsListController =
      BehaviorSubject<List<Post>>();

  Stream<List<Post>> get postsStream => postsListController.stream;

  int index = 0;

  Future<void> deleteStory(
    UserFollowersStories userFollowersStory,
    MiniStory story,
  ) async {
    database.deleteDocument(path: APIPath.storyDocument(story.storyId));
    database.setData(
      path: APIPath.userFollowerStoriesDocument(userFollowersStory.id),
      data: {
        'storiesIds': FieldValue.arrayRemove([story.toMap()])
      },
    );
  }

  Future<void> startFresh() async {
    index = 0;
    postsList.clear();
    postsIds.clear();
    await fetch10Posts();
  }

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
    final List<UserFollowersStories> data2 = await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) =>
          query.where('followers', arrayContains: currentUser.id),
      builder: (data, documentId) =>
          UserFollowersStories.fromMap(data, documentId),
    );
    // todo @low sort between stories that have been seen or not
    final List<UserFollowersStories> data3 = await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) =>
          query.where('miniUser.id', isEqualTo: currentUser.id),
      builder: (data, documentId) =>
          UserFollowersStories.fromMap(data, documentId),
    );
    final List<UserFollowersStories> list = List.empty(growable: true);
    list.addAll([...data3, ...data2]);
    final List<UserFollowersStories> listCleaned = [];
    storiesList = list;

    for (final UserFollowersStories element in list) {
      if (haveStories(element.miniUser)) {
        listCleaned.add(element);
      }
    }

    return listCleaned;
  }

  bool haveStories(MiniUser miniUser) {
    if (storiesList.isNotEmpty) {
      final UserFollowersStories data2 = storiesList
          .firstWhere((element) => element.miniUser.id == miniUser.id);
      if (data2.storiesIds.isNotEmpty) return true;
    }
    return false;
  }

  Future<Story?> getStory(MiniStory miniStory) {
    return database.fetchDocument(
      path: APIPath.storyDocument(miniStory.storyId),
      builder: (data, documentId) => Story.fromMap(data, documentId),
    );
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
