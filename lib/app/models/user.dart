import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/club.dart';

class User {
  User({
    required this.id,
    required this.type,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.following,
    required this.phoneNumber,
  });

  final String id;
  final int type;
  final String username;
  final String name;
  final String profilePicture;
  final String? bio;
  final int posts;
  final int followers;
  final int following;
  final String phoneNumber;

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
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

    return User(
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
  }

  factory User.fromMap2(Map<String, dynamic> data, String documentId) {
    final int type = data['type'] as int;

    User user = User.fromMap(data, documentId);
    if (type == 0) {
      user = Client.fromMap(data, documentId);
    } else if (type == 1) {
      user = Club.fromMap(data, documentId);
    } else if (type == 2) {
      // user = Agency.fromMap(data, documentId);
    } else if (type == 3) {
      //? for brand
    }

    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'username': username,
      'name': name,
      'profilePicture': profilePicture,
      'bio': bio,
      'posts': posts,
      'followers': followers,
      'following': following,
      'phoneNumber': phoneNumber,
    };
  }
}
