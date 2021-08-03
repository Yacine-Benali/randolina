import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_post.dart';
import 'package:randolina/app/models/mini_user.dart';

class UserFollowersPosts {
  UserFollowersPosts({
    required this.id,
    required this.lastPostTimestamp,
    // required this.isFull,
    required this.miniUser,
    required this.followers,
    required this.postsIds,
  });
  String id;
  Timestamp? lastPostTimestamp;
  // bool isFull;
  MiniUser miniUser;
  List<String> followers;
  List<MiniPost> postsIds;

  factory UserFollowersPosts.fromMap(
      Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final Timestamp? lastPostTimestamp =
        data['lastPostTimestamp'] as Timestamp?;
    // final bool isFull = data['isFull'] as bool;
    final MiniUser miniUser =
        MiniUser.fromMap(data['miniUser'] as Map<String, dynamic>);
    final List<String> followers =
        (data['followers'] as List<dynamic>).map((e) => e as String).toList();

    final List<MiniPost> postsIds = (data['postsIds'] as List<dynamic>)
        .map((e) => MiniPost.fromMap(e as Map<String, dynamic>))
        .toList();

    return UserFollowersPosts(
      id: id,
      lastPostTimestamp: lastPostTimestamp,
      // isFull: isFull,
      miniUser: miniUser,
      followers: followers,
      postsIds: postsIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastPostTimestamp': lastPostTimestamp,
      // isFull: isFull,
      'miniUser': miniUser,
      'followers': followers,
      'postsIds': postsIds,
    };
  }
}
