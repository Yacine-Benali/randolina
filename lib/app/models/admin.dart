class Admin {
  Admin({
    required this.id,
  });

  final String id;

  factory Admin.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;

    return Admin(
      id: id,
    );
  }
}
