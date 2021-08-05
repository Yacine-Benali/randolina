import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/app/models/user_followers_posts.dart';
import 'package:randolina/app/models/user_followers_stories.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class ProfileBloc {
  ProfileBloc({
    required this.database,
    required this.currentUser,
    required this.otherUser,
  });
  final Database database;
  final User currentUser;
  final User otherUser;

  //! todo @average add a provider and refactor
  // after doing the agency/club profile

  Future<void> saveClientProfile(String? bio, String activity) async {
    await database.setData(
      path: APIPath.userDocument(currentUser.id),
      data: {
        'bio': bio,
        'activity': activity,
      },
    );
  }

  Future<void> saveClubProfile(String? bio, List<String> activity) async {
    await database.setData(
      path: APIPath.userDocument(currentUser.id),
      data: {
        'bio': bio,
        'activities': activity,
      },
    );
  }

  Future<void> saveAgencyProfile(String? bio) async {
    await database.setData(
      path: APIPath.userDocument(currentUser.id),
      data: {
        'bio': bio,
      },
    );
  }

  Future<bool> isFollowing() async {
    logger.info('is: ${currentUser.id} following ${otherUser.id}');

    final List<UserFollowersStories> list1 = await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) => query
          .where('miniUser.id', isEqualTo: otherUser.id)
          .where('followers', arrayContains: currentUser.id),
      builder: (data, documentId) => UserFollowersStories.fromMap(
        data,
        documentId,
      ),
    );

    if (list1.isEmpty) {
      return false;
    } else if (list1.isNotEmpty) {
      return true;
    } else {
      logger.severe('BIG FUCKING ERROR');
      logger.severe(list1);
      return false;
    }
  }

  Future<void> followOtherUser() async {
    // call an api that gets user_followers_posts document that is not full
    // and do the following operations on it
    // if they fail because its full create a new one
    logger.info('Request: from ${currentUser.id} to following ${otherUser.id}');

    final UserFollowersStories lastVisitedUserStories =
        (await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) =>
          query.where('miniUser.id', isEqualTo: otherUser.id),
      builder: (data, documentId) => UserFollowersStories.fromMap(
        data,
        documentId,
      ),
    ))
            .first;

    final UserFollowersPosts lastVisitedUserPosts =
        (await database.fetchCollection(
      path: APIPath.userFollowerPostsCollection(),
      queryBuilder: (query) =>
          query.where('miniUser.id', isEqualTo: otherUser.id),
      builder: (data, documentId) => UserFollowersPosts.fromMap(
        data,
        documentId,
      ),
    ))
            .first;

    await database.updateData(
      path: APIPath.userFollowerPostsDocument(lastVisitedUserStories.id),
      data: {
        'followers': FieldValue.arrayUnion([currentUser.id])
      },
    );

    await database.updateData(
      path: APIPath.userFollowerStoriesDocument(lastVisitedUserPosts.id),
      data: {
        'followers': FieldValue.arrayUnion([currentUser.id])
      },
    );
  }

  Future<void> unfollowOtherUser() async {
    // call an api that gets user_followers_posts document that is not full
    // and do the following operations on it
    // if they fail because its full create a new one
    logger
        .info('Request: from ${currentUser.id} to unfollowing ${otherUser.id}');

    final UserFollowersStories lastVisitedUserStories =
        (await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) =>
          query.where('miniUser.id', isEqualTo: otherUser.id),
      builder: (data, documentId) => UserFollowersStories.fromMap(
        data,
        documentId,
      ),
    ))
            .first;

    final UserFollowersPosts lastVisitedUserPosts =
        (await database.fetchCollection(
      path: APIPath.userFollowerPostsCollection(),
      queryBuilder: (query) =>
          query.where('miniUser.id', isEqualTo: otherUser.id),
      builder: (data, documentId) => UserFollowersPosts.fromMap(
        data,
        documentId,
      ),
    ))
            .first;

    await database.updateData(
      path: APIPath.userFollowerPostsDocument(lastVisitedUserStories.id),
      data: {
        'followers': FieldValue.arrayRemove([currentUser.id])
      },
    );

    await database.updateData(
      path: APIPath.userFollowerStoriesDocument(lastVisitedUserPosts.id),
      data: {
        'followers': FieldValue.arrayRemove([currentUser.id])
      },
    );
  }

  Future<List<Post>> getPosts() async {
    return database.fetchCollection(
      path: APIPath.postsCollection(),
      queryBuilder: (query) => query
          .where('miniUser.id', isEqualTo: otherUser.id)
          .orderBy('createdAt', descending: true),
      builder: (data, id) => Post.fromMap(data, id),
    );
  }
}
