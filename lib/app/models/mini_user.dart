class MiniUser {
  MiniUser({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePicture,
  });

  final String id;
  final String profilePicture;
  final String name;
  final String username;

  factory MiniUser.fromMap(Map<String, dynamic> data) {
    final String id = data['id'] as String;
    final String username = data['username'] as String;
    final String name = data['name'] as String;
    final String profilePicture = data['profilePicture'] as String;

    return MiniUser(
      id: id,
      profilePicture: profilePicture,
      name: name,
      username: username,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profilePicture': profilePicture,
      'name': name,
      'username': username,
    };
  }
}
