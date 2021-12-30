import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/models/order.dart';
import 'package:randolina/app/models/product.dart';

class Message {
  Message({
    required this.id,
    required this.type,
    required this.content,
    required this.seen,
    required this.createdBy,
    required this.createdFor,
    required this.createdAt,
    this.product,
    this.order,
  });
  final String id;

  /// 0 for text
  /// 1 for photo
  /// 2 for product
  final int type;
  final String content;
  bool seen;
  final String createdBy;
  final String createdFor;
  final Timestamp createdAt;
  final Product? product;
  final Order? order;

  factory Message.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = documentId;
    final int type = data['type'] as int;
    final String content = data['content'] as String;
    final bool seen = data['seen'] as bool;
    final String createdBy = data['createdBy'] as String;
    final String createdFor = data['createdFor'] as String;
    final Timestamp createdAt =
        (data['createdAt'] as Timestamp?) ?? Timestamp.now();

    Product? product;
    if (data['product'] != null) {
      product = Product.fromMap(data['product'] as Map<String, dynamic>, '');
    }

    Order? order;
    if (data['order'] != null) {
      order = Order.fromMap(data['order'] as Map<String, dynamic>);
    }
    return Message(
      id: id,
      type: type,
      content: content,
      seen: seen,
      createdBy: createdBy,
      createdFor: createdFor,
      createdAt: createdAt,
      product: product,
      order: order,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'content': content,
      'seen': seen,
      'createdBy': createdBy,
      'createdFor': createdFor,
      'createdAt': FieldValue.serverTimestamp(),
      'product': product?.toMap(),
      'order': order?.toMap(),
    };
  }

  @override
  String toString() {
    print('message content: $content  timestamp: $createdAt ');
    return super.toString();
  }
}
