import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/user.dart';

class Client extends User {
  Client({
    required String id,
    required int type,
    required String username,
    required String name,
    required String profilePicture,
    required String? bio,
    required int posts,
    required int followers,
    required int following,
    required String phoneNumber,
    required bool isModerator,
    required int wilaya,

    //
    required this.activity,
    required this.dateOfBirth,
    required this.physicalCondition,
  }) : super(
          id: id,
          type: type,
          username: username,
          name: name,
          profilePicture: profilePicture,
          bio: bio,
          posts: posts,
          followers: followers,
          following: following,
          phoneNumber: phoneNumber,
          isModerator: isModerator,
          wilaya: wilaya,
        );

  final String activity;
  final Timestamp dateOfBirth;
  final String physicalCondition;

  factory Client.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final int type = data['type'] as int;
    final String username = data['username'] as String;
    final String name = data['name'] as String;
    final String profilePicture = data['profilePicture'] as String;
    final String? bio = data['bio'] as String?;
    final int posts = data['posts'] as int;
    final int followers = data['followers'] as int;
    final int following = data['following'] as int;
    final int wilaya = data['wilaya'] as int;
    final String phoneNumber = data['phoneNumber'] as String;
    //
    final String activity = data['activity'] as String;
    final Timestamp dateOfBirth = data['dateOfBirth'] as Timestamp;
    final String physicalCondition = data['physicalCondition'] as String;
    final bool isModerator = data['isModerator'] as bool;

    return Client(
      id: id,
      type: type,
      username: username,
      name: name,
      profilePicture: profilePicture,
      bio: bio,
      posts: posts,
      followers: followers,
      following: following,
      wilaya: wilaya,
      phoneNumber: phoneNumber,
      isModerator: isModerator,
      activity: activity,
      dateOfBirth: dateOfBirth,
      physicalCondition: physicalCondition,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final temp = super.toMap();
    temp.addAll({
      'wilaya': wilaya,
      'activity': activity,
      'dateOfBirth': dateOfBirth,
      'physicalCondition': physicalCondition,
    });
    return temp;
  }
}
