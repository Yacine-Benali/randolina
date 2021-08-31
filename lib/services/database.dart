import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Database {
  String getUniqueId();

  Future<String> uploadFile({
    required String path,
    required String filePath,
  });

  Future<T?> fetchDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  });

  Stream<T?> streamDocument<T>({
    required String path,
    required T Function(
      Map<String, dynamic> data,
      String documentID,
    )
        builder,
  });

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = true,
  });

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<void> addDocument({
    required String path,
    required Map<String, dynamic> data,
  });

  /// fetches a firestore collection in case its empty it returns an empty list
  Future<List<T>> fetchCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  });

  Stream<List<T>> streamCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  });

  // Future<T> fetchQueryDocument<T>({
  //   required String path,
  //   required T Function(Map<String, dynamic> data, String documentID) builder,
  //   required Query Function(Query query) queryBuilder,
  // });

  // Stream<T> queryDocument<T>({
  //   required String path,
  //   required T Function(Map<String, dynamic> data, String documentID) builder,
  //   required Query Function(Query query) queryBuilder,
  // });

  Future<void> deleteDocument({required String path});

}
