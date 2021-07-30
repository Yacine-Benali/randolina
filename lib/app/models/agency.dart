import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/user.dart';

class Agency extends User {
  Agency({
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
    //
    required this.address,
    required this.presidentName,
    required this.creationDate,
    required this.email,
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
        );

  final String address;
  final String presidentName;
  final Timestamp creationDate;
  final String email;

  factory Agency.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw Error();
    }
    final String id = documentId;
    final int type = data['type'] as int;
    final String username = data['username'] as String;
    final String name = data['name'] as String;
    final String profilePicture = data['profilePicture'] as String;
    final String? bio = data['bio'] as String?;
    final int posts = data['posts'] as int;
    final int followers = data['followers'] as int;
    final int following = data['following'] as int;
    final String phoneNumber = data['phoneNumber'] as String;
    //
    final String address = data['address'] as String;
    final String presidentName = data['presidentName'] as String;
    final Timestamp creationDate = data['creationDate'] as Timestamp;
    final String email = data['email'] as String;

    return Agency(
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
      //
      address: address,
      presidentName: presidentName,
      creationDate: creationDate,
      email: email,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final temp = super.toMap();
    temp.addAll({
      'address': address,
      'presidentName': presidentName,
      'creationDate': creationDate,
      'email': email,
    });
    return temp;
  }
}
