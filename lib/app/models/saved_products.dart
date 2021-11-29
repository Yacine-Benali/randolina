import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/utils/logger.dart';

class SavedProducts {
  SavedProducts({required this.list});
  final List<SavedProduct> list;

  factory SavedProducts.fromMap(Map<String, dynamic> data) {
    final List<String> eventsId =
        (data['eventsId'] as List<dynamic>).map((e) => e as String).toList();

    final List<Timestamp> savedAt =
        (data['savedAt'] as List<dynamic>).map((e) => e as Timestamp).toList();

    if (eventsId.length != savedAt.length) {
      logger
          .severe('SavedProducts Problem (savedAt.length != eventsId.length)');
      throw Exception('Unable to get saved posts');
    }

    final List<SavedProduct> list = [];
    for (var i = 0; i < eventsId.length; i++) {
      list.add(
        SavedProduct(
          productId: eventsId.elementAt(i),
          savedAt: savedAt.elementAt(i),
        ),
      );
    }

    return SavedProducts(
      list: list,
    );
  }
}

class SavedProduct {
  SavedProduct({
    required this.productId,
    required this.savedAt,
  });

  final String productId;
  final Timestamp savedAt;
}
