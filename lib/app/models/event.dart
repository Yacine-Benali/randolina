import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/home_admin/sites/site.dart';
import 'package:randolina/app/models/mini_subscriber.dart';
import 'package:randolina/app/models/mini_user.dart';

class Event {
  Event({
    required this.id,
    required this.images,
    required this.imagesPath,
    required this.profileImage,
    required this.profileImagePath,
    required this.destination,
    required this.price,
    required this.description,
    required this.walkingDistance,
    required this.startDateTime,
    required this.endDateTime,
    required this.difficulty,
    required this.instructions,
    required this.availableSeats,
    required this.createdBy,
    required this.createdByType,
    required this.subscribersLength,
    required this.subscribers,
    required this.createdAt,
    required this.wilaya,
    required this.site,
  });
  final String id;
  final List<String> images;
  final List<String> imagesPath;
  final String profileImage;
  final String profileImagePath;
  final String destination;
  final int price;
  final String description;
  final double walkingDistance;
  final Timestamp startDateTime;
  final Timestamp endDateTime;
  final int difficulty;
  final String instructions;
  final int availableSeats;
  final MiniUser createdBy;
  final int createdByType;
  final int subscribersLength;
  final List<MiniSubscriber> subscribers;
  final Timestamp createdAt;
  final int wilaya;
  final Site? site;
  // ignore: avoid_unused_constructor_parameters
  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    final List<String> images =
        (data['images'] as List<dynamic>).map((e) => e as String).toList();
    final List<String> imagesPath =
        (data['imagesPath'] as List<dynamic>).map((e) => e as String).toList();

    final String profileImage = data['profileImage'] as String;
    final String profileImagePath = data['profileImagePath'] as String;
    final String destination = data['destination'] as String;
    final int price = data['price'] as int;
    final String description = data['description'] as String;
    final double walkingDistance = data['walkingDistance'] as double;
    final Timestamp startDateTime = data['startDateTime'] as Timestamp;
    final Timestamp endDateTime = data['endDateTime'] as Timestamp;
    final int difficulty = data['difficulty'] as int;
    final String instructions = data['instructions'] as String;
    final int availableSeats = data['availableSeats'] as int;
    final MiniUser createdBy =
        MiniUser.fromMap(data['createdBy'] as Map<String, dynamic>);
    //
    final int createdByType = data['createdByType'] as int;
    final int subscribersLength = data['subscribersLength'] as int;
    //
    final List<MiniSubscriber> subscribers =
        (data['subscribers'] as List<dynamic>)
            .map((e) => MiniSubscriber.fromMap(e as Map<String, dynamic>))
            .toList();

    final Timestamp createdAt =
        data['createdAt'] as Timestamp? ?? Timestamp.now();
    final int wilaya = data['wilaya'] as int;
    Site? site;
    if (data['site'] != null) {
      site = Site.fromMap(data['site'] as Map<String, dynamic>, '');
    }

    return Event(
      id: documentId,
      images: images,
      imagesPath: imagesPath,
      profileImage: profileImage,
      profileImagePath: profileImagePath,
      destination: destination,
      price: price,
      description: description,
      walkingDistance: walkingDistance,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      difficulty: difficulty,
      instructions: instructions,
      availableSeats: availableSeats,
      createdBy: createdBy,
      createdByType: createdByType,
      subscribersLength: subscribersLength,
      subscribers: subscribers,
      createdAt: createdAt,
      wilaya: wilaya,
      site: site,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'imagesPath': imagesPath,
      'profileImage': profileImage,
      'profileImagePath': profileImagePath,
      'destination': destination,
      'price': price,
      'description': description,
      'walkingDistance': walkingDistance,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'difficulty': difficulty,
      'instructions': instructions,
      'availableSeats': availableSeats,
      'createdBy': createdBy.toMap(),
      'createdByType': createdByType,
      'subscribersLength': subscribersLength,
      'subscribers': subscribers.map((e) => e.toMap()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'wilaya': wilaya,
      'site': site?.toMap(),
    };
  }
}
