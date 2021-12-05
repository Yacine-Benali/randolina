import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:uuid/uuid.dart';

class ProductsBloc {
  ProductsBloc({
    required this.database,
    required this.authUser,
  });

  final Database database;
  final AuthUser authUser;
  final Uuid uuid = Uuid();
  final testDate =
      Timestamp.fromDate(DateTime.now().subtract(Duration(days: 365)));

  Future<String> uploadProductProfileImage(File file, String productId) async {
    return database.uploadFile(
      path: APIPath.productsFiles(authUser.uid, productId, uuid.v4()),
      filePath: file.path,
    );
  }

  Future<List<String>> uploadProductImages(List<File> images) async {
    final List<Future<String>> urls = [];
    for (final File file in images) {
      final t = database.uploadFile(
        path: APIPath.productsFiles(authUser.uid, '', uuid.v4()),
        filePath: file.path,
      );
      urls.add(t);
    }
    return Future.wait(urls);
  }

  List<Product> productsTextSearch(
    List<Product> events,
    String searchText,
  ) {
    final List<Product> matchedEvents = [];
    for (final Product event in events) {
      if (event.offer.toLowerCase().contains(searchText.toLowerCase())) {
        matchedEvents.add(event);
      }
    }
    return matchedEvents;
  }

  Future<void> saveProduct(Product product) async {
    await database.setData(
      path: APIPath.productDocument(authUser.uid),
      data: product.toMap(),
    );
  }

  Stream<List<Product>> getClientMyProducts() {
    final enddate = Timestamp.fromDate(DateTime.now());

    return database.streamCollection(
      path: APIPath.productsCollection(),
      builder: (data, documentId) => Product.fromMap(data, documentId),
      queryBuilder: (query) => query.where(
        'subscribers',
        arrayContainsAny: [
          {'id': authUser.uid, 'isConfirmed': false},
          {'id': authUser.uid, 'isConfirmed': true}
        ],
      ).where('endDateTime', isGreaterThan: enddate),
      sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Stream<List<Product>> getAllProducts() {
    return database.streamCollection(
      path: APIPath.productsCollection(),
      builder: (data, documentId) => Product.fromMap(data, documentId),
      queryBuilder: (query) => query.where(
        'createdBy.id',
        isNotEqualTo: authUser.uid,
      ),
      sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Stream<List<Product>> getMyProducts() {
    return database.streamCollection(
      path: APIPath.productsCollection(),
      builder: (data, documentId) => Product.fromMap(data, documentId),
      queryBuilder: (query) => query.where(
        'createdBy.id',
        isEqualTo: authUser.uid,
      ),
      sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Future<void> deleteProduct(Product product) async =>
      database.deleteDocument(path: APIPath.productDocument(product.id));
}
