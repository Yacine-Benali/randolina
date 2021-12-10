import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/conversation.dart';
import 'package:randolina/app/models/message.dart';
import 'package:randolina/app/models/order.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ProductsBloc {
  ProductsBloc({
    required this.database,
    required this.currentUser,
  });

  final Database database;
  final User currentUser;
  final Uuid uuid = Uuid();

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

  Future<String> uploadProductProfileImage(File file, String productId) async {
    return database.uploadFile(
      path: APIPath.productsFiles(currentUser.id, productId, uuid.v4()),
      filePath: file.path,
    );
  }

  Future<List<String>> uploadProductImages(List<File> images) async {
    final List<Future<String>> urls = [];
    for (final File file in images) {
      final t = database.uploadFile(
        path: APIPath.productsFiles(currentUser.id, '', uuid.v4()),
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
      path: APIPath.productDocument(product.id),
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
          {'id': currentUser.id, 'isConfirmed': false},
          {'id': currentUser.id, 'isConfirmed': true}
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
        isNotEqualTo: currentUser.id,
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
        isEqualTo: currentUser.id,
      ),
      sort: (Product a, Product b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Future<void> deleteProduct(Product product) async =>
      database.deleteDocument(path: APIPath.productDocument(product.id));
}
