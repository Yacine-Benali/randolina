import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_story.dart';
import 'package:randolina/app/models/mini_user.dart';

class UserFollowersStories {
  UserFollowersStories({
    required this.id,
    required this.lastStoryTimestamp,
    required this.miniUser,
    required this.followers,
    required this.storiesIds,
  });
  String id;
  Timestamp? lastStoryTimestamp;
  MiniUser miniUser;
  List<String> followers;
  List<MiniStory> storiesIds;

  factory UserFollowersStories.fromMap(
      Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final Timestamp? lastStoryTimestamp =
        data['lastStoryTimestamp'] as Timestamp?;
    final MiniUser miniUser =
        MiniUser.fromMap(data['miniUser'] as Map<String, dynamic>);
    final List<String> followers =
        (data['followers'] as List<dynamic>).map((e) => e as String).toList();
    late List<MiniStory> storiesIds;
    if ((data['storiesIds'] as List<dynamic>).isNotEmpty) {
      storiesIds = (data['storiesIds'] as List<dynamic>)
          .map((e) => MiniStory.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      storiesIds = [];
    }

    return UserFollowersStories(
      id: id,
      lastStoryTimestamp: lastStoryTimestamp,
      // isFull: isFull,
      miniUser: miniUser,
      followers: followers,
      storiesIds: storiesIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastStoryTimestamp': lastStoryTimestamp,
      'miniUser': miniUser,
      'followers': followers,
      'storiesIds': storiesIds,
    };
  }
}
