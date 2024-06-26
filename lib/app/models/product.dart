import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_user.dart';

class Product {
  Product({
    required this.id,
    required this.images,
    required this.imagesPath,
    required this.profileImage,
    required this.profileImagePath,
    required this.price,
    required this.specification,
    required this.offer,
    required this.colors,
    required this.sizes,
    required this.wilaya,
    required this.createdBy,
    required this.createdAt,
  });
  final String id;
  final List<String> images;
  final List<String> imagesPath;
  final String profileImage;
  final String profileImagePath;
  final int price;
  final String specification;
  final String offer;
  final List<dynamic> colors;
  final List<dynamic> sizes;
  final int wilaya;
  final MiniUser createdBy;
  final Timestamp createdAt;

  // ignore: avoid_unused_constructor_parameters
  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    final List<String> images =
        (data['images'] as List<dynamic>).map((e) => e as String).toList();
    final List<String> imagesPath =
        (data['imagesPath'] as List<dynamic>).map((e) => e as String).toList();

    final String profileImage = data['profileImage'] as String;
    final String profileImagePath = data['profileImagePath'] as String;
    final int price = data['price'] as int;
    final String specification = data['specification'] as String;
    final String offer = data['offer'] as String;
    final List<dynamic> colors = data['colors'] as List<dynamic>;
    final List<dynamic> sizes = data['sizes'] as List<dynamic>;
    final int wilaya = data['wilaya'] as int;
    final MiniUser createdBy =
        MiniUser.fromMap(data['createdBy'] as Map<String, dynamic>);
    final Timestamp createdAt =
        data['createdAt'] as Timestamp? ?? Timestamp.now();

    return Product(
      id: documentId,
      images: images,
      profileImage: profileImage,
      imagesPath: imagesPath,
      profileImagePath: profileImagePath,
      price: price,
      specification: specification,
      offer: offer,
      colors: colors,
      sizes: sizes,
      wilaya: wilaya,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'profileImage': profileImage,
      'imagesPath': imagesPath,
      'profileImagePath': profileImagePath,
      'price': price,
      'specification': specification,
      'offer': offer,
      'colors': colors,
      'sizes': sizes,
      'wilaya': wilaya,
      'createdBy': createdBy.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
