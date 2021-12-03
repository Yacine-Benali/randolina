import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_user.dart';

class Product {
  Product({
    required this.id,
    required this.images,
    required this.profileImage,
    required this.price,
    required this.specification,
    required this.offer,
    required this.colors,
    required this.sizes,
    required this.createdBy,
    required this.createdAt,
  });
  final String id;
  final List<String> images;
  final String profileImage;
  final int price;
  final String specification;
  final String offer;
  final List<dynamic> colors;
  final List<dynamic> sizes;
  final MiniUser createdBy;
  final Timestamp createdAt;

  // ignore: avoid_unused_constructor_parameters
  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    final List<String> images =
        (data['images'] as List<dynamic>).map((e) => e as String).toList();

    final String profileImage = data['profileImage'] as String;
    final int price = data['price'] as int;
    final String specification = data['specification'] as String;
    final String offer = data['offer'] as String;
    final List<dynamic> colors = data['colors'] as List<dynamic>;
    final List<dynamic> sizes = data['sizes'] as List<dynamic>;
    final MiniUser createdBy =
        MiniUser.fromMap(data['createdBy'] as Map<String, dynamic>);
    final Timestamp createdAt =
        data['createdAt'] as Timestamp? ?? Timestamp.now();

    return Product(
      id: documentId,
      images: images,
      profileImage: profileImage,
      price: price,
      specification: specification,
      offer: offer,
      colors: colors,
      sizes: sizes,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'profileImage': profileImage,
      'price': price,
      'specification': specification,
      'offer': offer,
      'colors': colors,
      'sizes': sizes,
      'createdBy': createdBy.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
