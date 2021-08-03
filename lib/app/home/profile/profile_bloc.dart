import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/client.dart';
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
    required this.otherClient,
  });
  final Database database;
  final User currentUser;
  final Client otherClient;

  //! todo @high add a provider and refactor
  // after doing the agency/club profile

  Future<void> saveChanges(String? bio, String activity) async {
    await database.setData(
      path: APIPath.userDocument(currentUser.id),
      data: {
        'bio': bio,
        'activity': activity,
      },
    );
  }

  Future<bool> isFollowing() async {
    logger.info('is: ${currentUser.id} following ${otherClient.id}');

    final List<UserFollowersStories> list1 = await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) => query
          .where('miniUser.id', isEqualTo: otherClient.id)
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
    logger
        .info('Request: from ${currentUser.id} to following ${otherClient.id}');

    final UserFollowersStories lastVisitedUserStories =
        (await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) =>
          query.where('miniUser.id', isEqualTo: otherClient.id),
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
          query.where('miniUser.id', isEqualTo: otherClient.id),
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
    logger.info(
        'Request: from ${currentUser.id} to unfollowing ${otherClient.id}');

    final UserFollowersStories lastVisitedUserStories =
        (await database.fetchCollection(
      path: APIPath.userFollowerStoriesCollection(),
      queryBuilder: (query) =>
          query.where('miniUser.id', isEqualTo: otherClient.id),
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
          query.where('miniUser.id', isEqualTo: otherClient.id),
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
}
