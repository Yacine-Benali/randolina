// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:randolina/app/models/user.dart';

// class Agency extends User {
//   Agency({
//     required String id,
//     required int type,
//     required String username,
//     required String name,
//     required String profilePicture,
//     required String? bio,
//     required int posts,
//     required int followers,
//     required int following,
//     required int wilaya,
//     required String phoneNumber,
//     //
//     required this.activities,
//     required this.presidentName,
//     required this.creationDate,
//     required this.email,
//     required this.members,
//   }) : super(
//           id: id,
//           type: type,
//           username: username,
//           name: name,
//           profilePicture: profilePicture,
//           bio: bio,
//           posts: posts,
//           followers: followers,
//           following: following,
//           wilaya: wilaya,
//           phoneNumber: phoneNumber,
//         );

//   final List<String> activities;
//   final String presidentName;
//   final Timestamp creationDate;
//   final String email;
//   final int members;

//   factory Agency.fromMap(Map<String, dynamic>? data, String documentId) {
//     if (data == null) {
//       throw Error();
//     }
//     final String id = documentId;
//     final int type = data['type'] as int;
//     final String username = data['username'] as String;
//     final String name = data['name'] as String;
//     final String profilePicture = data['profilePicture'] as String;
//     final String? bio = data['bio'] as String?;
//     final int posts = data['posts'] as int;
//     final int followers = data['followers'] as int;
//     final int following = data['following'] as int;
//     final int wilaya = data['wilaya'] as int;
//     final String phoneNumber = data['phoneNumber'] as String;
//     //
//     final List<String> activities = data['activities'] as List<String>;
//     final String presidentName = data['presidentName'] as String;
//     final Timestamp creationDate = data['creationDate'] as Timestamp;
//     final String email = data['email'] as String;
//     final int members = data['members'] as int;

//     return Agency(
//       id: id,
//       type: type,
//       username: username,
//       name: name,
//       profilePicture: profilePicture,
//       bio: bio,
//       posts: posts,
//       followers: followers,
//       following: following,
//       wilaya: wilaya,
//       phoneNumber: phoneNumber,
//       //
//       activities: activities,
//       presidentName: presidentName,
//       creationDate: creationDate,
//       email: email,
//       members: members,
//     );
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     final temp = super.toMap();
//     temp.addAll({
//       'activities': activities,
//       'presidentName': presidentName,
//       'creationDate': creationDate,
//       'email': email,
//       'members': members,
//     });
//     return temp;
//   }
// }
