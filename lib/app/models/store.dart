import 'package:randolina/app/models/user.dart';

class Store extends User {
  Store({
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
    required bool isModerator,
    required int wilaya,
    //
    required this.address,
    required this.ownerName,
    required this.email,
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
  final String ownerName;
  final String email;

  factory Store.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final int type = data['type'] as int;
    final String username = data['username'] as String;
    final String name = data['name'] as String;
    final String profilePicture = data['profilePicture'] as String;
    final String profilePicturePath = data['profilePicturePath'] as String;
    final String? bio = data['bio'] as String?;
    final int posts = data['posts'] as int;
    final int followers = data['followers'] as int;
    final int following = data['following'] as int;
    final String phoneNumber = data['phoneNumber'] as String;
    //
    final String address = data['address'] as String;
    final String ownerName = data['ownerName'] as String;
    final String email = data['email'] as String;
    final bool isModerator = data['isModerator'] as bool;
    final int wilaya = data['wilaya'] as int;

    return Store(
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
      isModerator: isModerator,
      wilaya: wilaya,
      //
      address: address,
      ownerName: ownerName,
      email: email,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final temp = super.toMap();
    temp.addAll({
      'address': address,
      'ownerName': ownerName,
      'email': email,
    });
    return temp;
  }
}
