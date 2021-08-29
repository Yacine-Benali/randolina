import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event({
    required this.images,
    required this.profileImage,
    required this.destination,
    required this.price,
    required this.description,
    required this.walkingDistance,
    required this.startDateTime,
    required this.endDateTime,
    required this.difficulty,
    required this.instructions,
    required this.availableSeats,
  });

  final List<String> images;
  final String profileImage;
  final String destination;
  final double price;
  final String description;
  final double walkingDistance;
  final Timestamp startDateTime;
  final Timestamp endDateTime;
  final int difficulty;
  final String instructions;
  final int availableSeats;
}
