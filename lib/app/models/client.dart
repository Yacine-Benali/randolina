import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/user.dart';

class Client extends User {
  Client({
    required String id,
    required String username,
    required String name,
    required String profilePicture,
    required String bio,
    required int posts,
    required int followers,
    required int following,
    required int wilaya,
    required String phoneNumber,

    //
    required this.activity,
    required this.dateOfBirth,
    required this.address,
    required this.physicalCondition,
  }) : super(
          id: id,
          username: username,
          name: name,
          profilePicture: profilePicture,
          bio: bio,
          posts: posts,
          followers: followers,
          following: following,
          wilaya: wilaya,
          phoneNumber: phoneNumber,
        );

  final String activity;
  final Timestamp dateOfBirth;
  final String address;
  final String physicalCondition;

  factory Client.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw Error();
    }
    final String id = documentId;
    final String username = data['username'] as String;
    final String name = data['name'] as String;
    final String profilePicture = data['profilePicture'] as String;
    final String bio = data['bio'] as String;
    final int posts = data['posts'] as int;
    final int followers = data['followers'] as int;
    final int following = data['following'] as int;
    final int wilaya = data['wilaya'] as int;
    final String phoneNumber = data['phoneNumber'] as String;

    //
    final String activity = data['activity'] as String;
    final Timestamp dateOfBirth = data['dateOfBirth'] as Timestamp;
    final String address = data['address'] as String;
    final String physicalCondition = data['physicalCondition'] as String;

    return Client(
      id: id,
      username: username,
      name: name,
      profilePicture: profilePicture,
      bio: bio,
      posts: posts,
      followers: followers,
      following: following,
      wilaya: wilaya,
      phoneNumber: phoneNumber,
      activity: activity,
      dateOfBirth: dateOfBirth,
      address: address,
      physicalCondition: physicalCondition,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final temp = super.toMap();
    temp.addAll({
      'activity': activity,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'physicalCondition': physicalCondition,
    });
    return temp;
  }
}
