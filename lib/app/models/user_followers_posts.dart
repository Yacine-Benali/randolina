import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_post.dart';

class UserFollowersPosts {
  UserFollowersPosts({
    required this.id,
    required this.lastPostTimestamp,
    required this.followers,
    required this.postsIds,
  });
  String id;
  Timestamp? lastPostTimestamp;

  List<String> followers;
  List<MiniPost> postsIds;

  factory UserFollowersPosts.fromMap(
      Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final Timestamp? lastPostTimestamp =
        data['lastPostTimestamp'] as Timestamp?;

    final List<String> followers =
        (data['followers'] as List<dynamic>).map((e) => e as String).toList();

    final List<MiniPost> postsIds = (data['postsIds'] as List<dynamic>)
        .map((e) => MiniPost.fromMap(e as Map<String, dynamic>))
        .toList();

    return UserFollowersPosts(
      id: id,
      lastPostTimestamp: lastPostTimestamp,
      followers: followers,
      postsIds: postsIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastPostTimestamp': lastPostTimestamp,
      'followers': followers,
      'postsIds': postsIds,
    };
  }
}
