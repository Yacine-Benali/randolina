import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/saved_posts.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/app/models/user_followers_posts.dart';
import 'package:randolina/app/models/user_followers_stories.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:randolina/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ProfileBloc {
  ProfileBloc({
    required this.database,
    required this.currentUser,
    required this.otherUser,
  });
  final Database database;
  final User currentUser;
  final User otherUser;

  //! TODO @average add a provider and refactor
  // after doing the agency/club profile
  Stream<UserFollowersPosts?> getUserFollowersPost() => database.streamDocument(
        path: APIPath.userFollowerPostsDocument(currentUser.id),
        builder: (data, id) => UserFollowersPosts.fromMap(data, id),
      );

  Future<void> saveClientProfile(
    String? bio,
    String activity,
    File? profileImage,
  ) async {
    if (profileImage != null) {
      final Uuid uuid = Uuid();
      final String url = await database.uploadFile(
        path: APIPath.userProfilePicture(currentUser.id, uuid.v4()),
        filePath: profileImage.path,
      );
      await database.setData(
        path: APIPath.userDocument(currentUser.id),
        data: {
          'profilePicture': url,
          'bio': bio,
          'activity': activity,
        },
      );
    } else {
      await database.setData(
        path: APIPath.userDocument(currentUser.id),
        data: {
          'bio': bio,
          'activity': activity,
        },
      );
    }
  }

  Future<void> saveClubProfile(
    String? bio,
    List<String> activity,
    File? profileImage,
  ) async {
    if (profileImage != null) {
      final Uuid uuid = Uuid();
      final String url = await database.uploadFile(
        path: APIPath.userProfilePicture(currentUser.id, uuid.v4()),
        filePath: profileImage.path,
      );
      await database.setData(
        path: APIPath.userDocument(currentUser.id),
        data: {
          'profilePicture': url,
          'bio': bio,
          'activities': activity,
        },
      );
    } else {
      await database.setData(
        path: APIPath.userDocument(currentUser.id),
        data: {
          'bio': bio,
          'activities': activity,
        },
      );
    }
  }

  Future<void> saveAgencyStoreProfile(
    String? bio,
    File? profileImage,
  ) async {
    if (profileImage != null) {
      final Uuid uuid = Uuid();
      final String url = await database.uploadFile(
        path: APIPath.userProfilePicture(currentUser.id, uuid.v4()),
        filePath: profileImage.path,
      );
      await database.setData(
        path: APIPath.userDocument(currentUser.id),
        data: {
          'profilePicture': url,
          'bio': bio,
        },
      );
    } else {
      await database.setData(
        path: APIPath.userDocument(currentUser.id),
        data: {
          'bio': bio,
        },
      );
    }
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
      logger.severe('Error FUCKING ERROR');
      return false;
    }
  }

  // TODO @low this is not the best for security and longterm use
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
      queryBuilder: (query) => query.where('id', isEqualTo: otherUser.id),
      builder: (data, documentId) => UserFollowersPosts.fromMap(
        data,
        documentId,
      ),
    ))
            .first;

    final batch = FirebaseFirestore.instance.batch();

    batch.update(
      FirebaseFirestore.instance
          .doc(APIPath.userFollowerPostsDocument(lastVisitedUserStories.id)),
      {
        'followers': FieldValue.arrayUnion([currentUser.id]),
        'length': FieldValue.increment(1),
      },
    );

    batch.update(
      FirebaseFirestore.instance
          .doc(APIPath.userFollowerStoriesDocument(lastVisitedUserPosts.id)),
      {
        'followers': FieldValue.arrayUnion([currentUser.id]),
        'length': FieldValue.increment(1),
      },
    );
    batch.update(
        FirebaseFirestore.instance.doc(APIPath.userDocument(currentUser.id)),
        {'following': FieldValue.increment(1)});
    //
    batch.update(
        FirebaseFirestore.instance.doc(APIPath.userDocument(otherUser.id)),
        {'followers': FieldValue.increment(1)});

    batch.set(
        FirebaseFirestore.instance.doc(
          APIPath.conversationDocument(createConversation(
            currentUser.toMiniUser(),
            otherUser.toMiniUser(),
          ).id),
        ),
        createConversation(
          currentUser.toMiniUser(),
          otherUser.toMiniUser(),
        ).toMap());

    await batch.commit();
  }

  // same as above
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
      queryBuilder: (query) => query.where('id', isEqualTo: otherUser.id),
      builder: (data, documentId) => UserFollowersPosts.fromMap(
        data,
        documentId,
      ),
    ))
            .first;

    final batch = FirebaseFirestore.instance.batch();

    batch.update(
      FirebaseFirestore.instance
          .doc(APIPath.userFollowerPostsDocument(lastVisitedUserStories.id)),
      {
        'followers': FieldValue.arrayRemove([currentUser.id]),
        'length': FieldValue.increment(1),
      },
    );
    batch.update(
      FirebaseFirestore.instance
          .doc(APIPath.userFollowerStoriesDocument(lastVisitedUserPosts.id)),
      {
        'followers': FieldValue.arrayRemove([currentUser.id]),
        'length': FieldValue.increment(-1),
      },
    );
    batch.update(
      FirebaseFirestore.instance.doc(APIPath.userDocument(currentUser.id)),
      {'following': FieldValue.increment(-1)},
    );
    batch.update(
      FirebaseFirestore.instance.doc(APIPath.userDocument(otherUser.id)),
      {'followers': FieldValue.increment(-1)},
    );

    await batch.commit();
  }

  Future<List<Post>> getPosts({required bool showProfileAsOther}) async {
    final String uid = showProfileAsOther ? otherUser.id : currentUser.id;
    return database.fetchCollection(
      path: APIPath.postsCollection(),
      queryBuilder: (query) => query
          .where('miniUser.id', isEqualTo: uid)
          .orderBy('createdAt', descending: true),
      builder: (data, id) => Post.fromMap(data, id),
    );
  }

  List<Post> sortPost(List<Post> posts, int type) {
    final List<Post> list = [];

    for (final Post post in posts) {
      switch (type) {
        case 0:
          list.add(post);
          break;
        case 1:
          if (post.type == 0) {
            list.add(post);
          }
          break;
        case 2:
          if (post.type > 0) {
            list.add(post);
          }
          break;
      }
    }

    return list;
  }

  Future<List<Post>> getSavedPosts() async {
    final List<SavedPosts> savedPosts = await database.fetchCollection(
      path: APIPath.savedPostsCollection(currentUser.id),
      builder: (data, id) => SavedPosts.fromMap(data),
    );

    final List<Future<Post?>> futures = [];

    if (savedPosts.isNotEmpty) {
      final List<SavedPost> temp =
          savedPosts.map((e) => e.list).toList().expand((e) => e).toList();
      //
      final List<String> savedPostIds = temp.map((e) => e.postId).toList();

      for (final String postId in savedPostIds) {
        final Future<Post?> futurePost = database.fetchDocument(
          path: APIPath.postDocument(postId),
          builder: (data, documentId) => Post.fromMap(data, documentId),
        );
        futures.add(futurePost);
      }

      final List<Post?> p = (await Future.wait(futures)).toList();
      final List<Post> pp = List.from(p.where((element) => element != null));
      pp.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      return pp;
    } else {
      return [];
    }
  }

  Stream<List<Event>> getClubAllEvents() {
    final dateNow = Timestamp.fromDate(DateTime.now());

    return database
        .streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where('createdBy.id', isEqualTo: otherUser.id)
          .where('startDateTime', isGreaterThan: dateNow),
      sort: (Event a, Event b) => a.createdAt.compareTo(b.createdAt) * -1,
    )
        .map((events) {
      return events.where((event) {
        return event.availableSeats > event.subscribers.length;
      }).toList();
    });
  }

  Stream<List<Product>> getStoreAllProducts(String idStore) {
    return database.streamCollection(
      path: APIPath.productsCollection(),
      builder: (data, documentId) => Product.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where(
            'createdBy.id',
            isEqualTo: idStore,
          )
          .limit(10),
      sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }
}
