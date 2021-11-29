import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/mini_subscriber.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/saved_products.dart';
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
  SavedProducts? savedProducts;
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

  Future<void> saveProduct(Product product) async => database.setData(
        path: APIPath.productDocument(product.id),
        data: product.toMap(),
      );
  //fonction a modifier
  // Stream<List<Product>> getStoreAllProducts() {
  //   final enddate = Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));
  //   //! TODO @high paginate, combine allProducts
  //   //! only show myProducts from all Products
  //   return database
  //       .streamCollection(
  //     path: APIPath.productsCollection(),
  //     builder: (data, documentId) => Product.fromMap(data, documentId),
  //     queryBuilder: (query) =>
  //         query.where('endDateTime', isGreaterThan: enddate),
  //     sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
  //   )
  //       .map((products) {
  //     return products.where((product) {
  //       return Product.createdBy.id != authUser.uid;
  //     }).toList();
  //   });
  // }

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

  Stream<List<Product>> getClientAllProducts() {
    final enddate = Timestamp.fromDate(DateTime.now());

    //! TODO @high paginate
    return database.streamCollection(
      path: APIPath.productsCollection(),
      builder: (data, documentId) => Product.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.where('endDateTime', isGreaterThan: enddate),
      sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Future<void> deleteProduct(Product product) async =>
      database.deleteDocument(path: APIPath.productDocument(product.id));

  Future<void> subscribeToProduct(Product product) async {
    final miniSubscriber = MiniSubscriber(id: authUser.uid, isConfirmed: false);
    await database.updateData(
      path: APIPath.productDocument(product.id),
      data: {
        'subscribers': FieldValue.arrayUnion([miniSubscriber.toMap()])
      },
    );
  }

  // List<Product> productsTextSearch(
  //   List<Product> products,
  //   String searchText,
  //   int searchWilaya,
  // ) {
  //   final List<Product> matchedProducts = [];
  //   for (final Product Product in products) {
  //     if (searchWilaya == 0) {
  //       if (product.destination
  //           .toLowerCase()
  //           .contains(searchText.toLowerCase())) {
  //         matchedProducts.add(Product);
  //       }
  //     } else {
  //       if (product.destination
  //               .toLowerCase()
  //               .contains(searchText.toLowerCase()) &&
  //           product.wilaya == searchWilaya) {
  //         matchedProducts.add(Product);
  //       }
  //     }
  //   }
  //   return matchedProducts;
  // }

  // List<Product> filtreProducts(
  //   List<Product> products,
  //   String searchText,
  //   ProductCreatedBy productCreatedBy,
  //   SfRangeValues sfRangeValues,
  // ) {
  //   final List<Product> matchedProducts = [];

  //   for (final Product Product in products) {
  //     if (product.destination
  //             .toLowerCase()
  //             .contains(searchText.toLowerCase()) &&
  //         (product.price >= (sfRangeValues.start as num).toInt()) &&
  //         product.price <= (sfRangeValues.end as num).toInt()) {
  //       if (productCreatedBy == productCreatedBy.clubOnly &&
  //           product.createdByType == 1) {
  //         matchedProducts.add(Product);
  //       } else if (productCreatedBy == productCreatedBy.agencyOnly &&
  //           product.createdByType == 2) {
  //         matchedProducts.add(Product);
  //       } else if (productCreatedBy == productCreatedBy.both) {
  //         matchedProducts.add(Product);
  //       }
  //     }
  //   }
  //   return matchedProducts;
  // }

  Future<void> getSavedProducts() async {
    final SavedProducts? savedProducts = await database.fetchDocument(
      path: APIPath.savedProductDocument(authUser.uid),
      builder: (data, id) => SavedProducts.fromMap(data),
    );
    this.savedProducts = savedProducts;
  }

  Future<void> saveProductToFavorite(Product product) async {
    await database.setData(
      path: APIPath.savedProductDocument(authUser.uid),
      data: {
        'productsId': FieldValue.arrayUnion([product.id]),
        'savedAt': FieldValue.arrayUnion([Timestamp.now()])
      },
    );
    await getSavedProducts();
  }

  Future<void> unsaveProductFromFavorite(Product product) async {
    if (savedProducts != null) {
      final SavedProduct savedProduct = savedProducts!.list
          .firstWhere((element) => element.productId == product.id);
      await database.setData(
        path: APIPath.savedProductDocument(authUser.uid),
        data: {
          'productsId': FieldValue.arrayRemove([savedProduct.productId]),
          'savedAt': FieldValue.arrayRemove([savedProduct.savedAt])
        },
      );
    }
    await getSavedProducts();
  }
}
