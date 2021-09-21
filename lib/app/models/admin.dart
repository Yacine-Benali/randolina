import 'package:randolina/app/models/user.dart';

class Admin extends User {
  Admin({
    required this.id,
  }) : super(
          id: id,
          type: 0,
          username: 'username',
          name: 'name',
          profilePicture: 'profilePicture',
          bio: 'bio',
          posts: 0,
          followers: 0,
          following: 0,
          phoneNumber: '0',
          isModerator: false,
        );

  final String id;

  factory Admin.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;

    return Admin(
      id: id,
    );
  }
}
