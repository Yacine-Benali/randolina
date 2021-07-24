class User {
  User({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.following,
    required this.wilaya,
    required this.phoneNumber,
  });

  final String id;
  final String username;
  final String name;
  final String profilePicture;
  final String bio;
  final int posts;
  final int followers;
  final int following;
  final int wilaya;
  final String phoneNumber;

  factory User.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw Error();
    }
    final String id = documentId;
    final String username = data['username'] as String;
    final String name = data['name'] as String;
    final String profilePicture = data['profilePicture'] as String;
    final String bio = data['bio'] as String;
    final int posts = int.parse(data['posts'] as String);
    final int followers = int.parse(data['followers'] as String);
    final int following = int.parse(data['following'] as String);
    final int wilaya = data['wilaya'] as int;
    final String phoneNumber = data['phoneNumber'] as String;

    return User(
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
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profilePicture': profilePicture,
      'bio': bio,
      'posts': posts,
      'followers': followers,
      'following': following,
      'wilaya': wilaya,
      'phoneNumber': phoneNumber,
    };
  }
}
