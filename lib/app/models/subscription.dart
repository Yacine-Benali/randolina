import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  Subscription({
    required this.id,
    required this.isApproved,
    required this.isActive,
    required this.endsAt,
    required this.startsAt,
  });

  bool isApproved;
  bool isActive;
  Timestamp? endsAt;
  Timestamp? startsAt;
  String id;
  factory Subscription.fromMap(Map<String, dynamic> data, String documentId) {
    final bool isApproved = data['isApproved'] as bool;
    final bool isActive = data['isActive'] as bool;
    final Timestamp? endsAt = data['endsAt'] as Timestamp?;
    final Timestamp? startsAt = data['startsAt'] as Timestamp?;

    return Subscription(
      id: documentId,
      isApproved: isApproved,
      isActive: isActive,
      endsAt: endsAt,
      startsAt: startsAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isApproved': isApproved,
      'isActive': isActive,
      'endsAt': endsAt,
      'startsAt': startsAt,
    };
  }
}
