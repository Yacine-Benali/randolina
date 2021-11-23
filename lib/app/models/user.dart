import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/store.dart';

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
    required this.isModerator,
    required this.wilaya,
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
  final bool isModerator;
  final int wilaya;

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
    final bool isModerator = data['isModerator'] as bool;
    final int wilaya = data['wilaya'] as int;

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
      isModerator: isModerator,
      wilaya: wilaya,
    );
  }

  factory User.fromMap2(Map<String, dynamic> data, String documentId) {
    final int type = data['type'] as int;
    if (type == 0) {
      return Client.fromMap(data, documentId);
    } else if (type == 1) {
      return Club.fromMap(data, documentId);
    } else if (type == 2) {
      return Agency.fromMap(data, documentId);
    } else if (type == 3) {
      return Store.fromMap(data, documentId);
    }
    return User.fromMap(data, documentId);
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
      'isModerator': isModerator,
      'wilaya': wilaya,
    };
  }

  MiniUser toMiniUser() {
    return MiniUser(
      id: id,
      username: username,
      name: name,
      profilePicture: profilePicture,
    );
  }
}
