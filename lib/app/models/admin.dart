import 'package:randolina/app/models/user.dart';

class Admin extends User {
  Admin({
    required String id,
  }) : super(
          id: id,
          type: 0,
          username: 'username',
          name: 'name',
          profilePicture: 'profilePicture',
          profilePicturePath: 'profilePicturePath',
          bio: 'bio',
          posts: 0,
          followers: 0,
          following: 0,
          phoneNumber: '0',
          isModerator: false,
          wilaya: 31,
        );

  // ignore: avoid_unused_constructor_parameters
  factory Admin.fromMap(Map<String, dynamic> data, String documentId) {
    return Admin(
      id: documentId,
    );
  }
}
