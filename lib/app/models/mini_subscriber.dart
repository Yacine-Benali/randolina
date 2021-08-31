class MiniSubscriber {
  MiniSubscriber({
    required this.id,
    required this.isConfirmed,
  });

  String id;
  bool isConfirmed;

  factory MiniSubscriber.fromMap(Map<String, dynamic> data) {
    final String id = data['id'] as String;
    final bool isConfirmed = data['isConfirmed'] as bool;

    return MiniSubscriber(
      id: id,
      isConfirmed: isConfirmed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isConfirmed': isConfirmed,
    };
  }
}
