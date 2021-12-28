import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/user.dart';

class Club extends User {
  Club({
    required String id,
    required int type,
    required String username,
    required String name,
    required String profilePicture,
    required String profilePicturePath,
    required String? bio,
    required int posts,
    required int followers,
    required int following,
    required String phoneNumber,
    required int wilaya,
    required bool isModerator,
    //
    required this.address,
    required this.activities,
    required this.presidentName,
    required this.creationDate,
    required this.email,
    required this.members,
  }) : super(
          id: id,
          type: type,
          username: username,
          name: name,
          profilePicture: profilePicture,
          profilePicturePath: profilePicturePath,
          bio: bio,
          posts: posts,
          followers: followers,
          following: following,
          phoneNumber: phoneNumber,
          wilaya: wilaya,
          isModerator: isModerator,
        );
  final String address;
  final List<String> activities;
  final String presidentName;
  final Timestamp creationDate;
  final String email;
  final int members;

  factory Club.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final int type = data['type'] as int;
    final String username = data['username'] as String;
    final String profilePicturePath = data['profilePicturePath'] as String;
    final String name = data['name'] as String;
    final String profilePicture = data['profilePicture'] as String;
    final String? bio = data['bio'] as String?;
    final int posts = data['posts'] as int;

    final int followers = data['followers'] as int;
    final int following = data['following'] as int;

    final String phoneNumber = data['phoneNumber'] as String;
    final int wilaya = data['wilaya'] as int;

    //
    final String address = data['address'] as String;
    final List<String> activities =
        (data['activities'] as List<dynamic>).map((e) => e as String).toList();

    final String presidentName = data['presidentName'] as String;
    final Timestamp creationDate = data['creationDate'] as Timestamp;
    final String email = data['email'] as String;
    final int members = data['members'] as int;
    final bool isModerator = data['isModerator'] as bool;

    return Club(
      id: id,
      type: type,
      username: username,
      name: name,
      profilePicture: profilePicture,
      profilePicturePath: profilePicturePath,
      bio: bio,
      posts: posts,
      followers: followers,
      following: following,
      address: address,
      phoneNumber: phoneNumber,
      isModerator: isModerator,
      wilaya: wilaya,
      //
      activities: activities,
      presidentName: presidentName,
      creationDate: creationDate,
      email: email,
      members: members,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final temp = super.toMap();
    temp.addAll({
      'activities': activities,
      'presidentName': presidentName,
      'creationDate': creationDate,
      'email': email,
      'members': members,
      'address': address,
    });
    return temp;
  }
}
