import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/message.dart';
import 'package:randolina/app/models/order.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/subscription.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:randolina/utils/utils.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

// TODO @high verify store subscription
class ProductsBloc {
  ProductsBloc({
    required this.database,
    required this.currentUser,
  });

  final Database database;
  final User currentUser;
  final Uuid uuid = Uuid();

  Stream<Subscription?> getClubSubscription(String clubId) {
    return database.streamDocument(
      path: APIPath.subscriptionsDocument(clubId),
      builder: (data, documentId) => Subscription.fromMap(data, documentId),
    );
  }

  Future<void> orderProduct(Product product, Order order) async {
    final Conversation conversation =
        createConversation(currentUser.toMiniUser(), product.createdBy);
    final Message orderMessage = Message(
      id: 'id',
      type: 2,
      content: '',
      seen: false,
      createdBy: currentUser.id,
      createdAt: Timestamp.now(),
      product: product,
      order: order,
    );
    final batch = FirebaseFirestore.instance.batch();

    batch.set(
        FirebaseFirestore.instance
            .doc(APIPath.conversationDocument(conversation.id)),
        conversation.toMap());

    batch.set(
        FirebaseFirestore.instance
            .doc(APIPath.messageDocument(conversation.id, uuid.v4())),
        orderMessage.toMap());

    await batch.commit();
  }

  bool isSubscriptionActive(Subscription subscription) {
    if (subscription.isActive == true &&
        subscription.isApproved == true &&
        subscription.startsAt != null &&
        subscription.endsAt != null) {
      final DateTime today = DateTime.now();
      final bool isAfter = today.isAfter(subscription.startsAt!.toDate());
      final bool isBefore = today.isBefore(subscription.endsAt!.toDate());
      return isAfter && isBefore;
    } else {
      return false;
    }
  }

  String getProductImagePath(String productId) =>
      APIPath.productsFiles(currentUser.id, productId, uuid.v4());

  Future<String> uploadProductProfileImage(
      File file, String productPath) async {
    return database.uploadFile(
      path: productPath,
      filePath: file.path,
    );
  }

  Future<Tuple2<List<String>, List<String>>> uploadProductImages(
      List<File> images, String productId) async {
    final List<Future<String>> urlsFuture = [];
    final List<String> paths = [];
    for (final File file in images) {
      final String path = getProductImagePath(productId);
      final t = database.uploadFile(
        path: path,
        filePath: file.path,
      );
      paths.add(path);
      urlsFuture.add(t);
    }
    final List<String> urls = await Future.wait(urlsFuture);
    return Tuple2(urls, paths);
  }

  List<Product> productsFilter(
    List<Product> products,
    SfRangeValues priceRange,
    int wilaya,
  ) {
    try {
      final double start = double.parse(priceRange.start.toString());
      final double end = double.parse(priceRange.end.toString());
      final List<Product> matchedProducts = [];
      for (final Product p in products) {
        if (p.price >= start && p.price <= end && p.wilaya == wilaya) {
          matchedProducts.add(p);
        }
      }
      return matchedProducts;
    } on Exception catch (e) {
      logger.severe('productsFilter ERROR');
      logger.severe(e);
      return [];
    }
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
      path: APIPath.productDocument(product.id),
      data: product.toMap(),
    );
  }

  Stream<List<Product>> getAllProducts() {
    return database.streamCollection(
        path: APIPath.productsCollection(),
        builder: (data, documentId) => Product.fromMap(data, documentId),
        queryBuilder: (query) => query.where(
              'createdBy.id',
              isNotEqualTo: currentUser.id,
            ),
        sort: (Product a, Product b) {
          if (a.wilaya == currentUser.wilaya) {
            return -1;
          } else {
            return 1;
          }
        });
  }

  Stream<List<Product>> getMyProducts() {
    return database.streamCollection(
      path: APIPath.productsCollection(),
      builder: (data, documentId) => Product.fromMap(data, documentId),
      queryBuilder: (query) => query.where(
        'createdBy.id',
        isEqualTo: currentUser.id,
      ),
      sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Future<void> deleteProduct(Product product) async =>
      database.deleteDocument(path: APIPath.productDocument(product.id));
}
