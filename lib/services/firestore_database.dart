import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:randolina/services/database.dart';

class FirestoreDatabase implements Database {
//! <Map<String, dynamic>>
  @override
  String getUniqueId() {
    final String _randomId =
        FirebaseFirestore.instance.collection(' ').doc().id;
    return _randomId;
  }

  @override
  Future<String> uploadFile({
    required String path,
    required String filePath,
  }) async {
    // Create a Reference to the file
    final Reference ref = FirebaseStorage.instance.ref(path);

    final UploadTask uploadTask = ref.putFile(File(filePath));
    final TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() {});
    final String result = await storageTaskSnapshot.ref.getDownloadURL();
    return result;
  }

  @override
  Future<T?> fetchDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
  }) async {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await reference.get();

    if (snapshot.data() != null) {
      return builder(
        snapshot.data()!,
        snapshot.id,
      );
    } else {
      return null;
    }
  }

  @override
  Stream<T?> streamDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      return builder(snapshot.data()!, snapshot.id);
    });
  }

  @override
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    final dcumentReference = FirebaseFirestore.instance.doc(path);
    print('set $path: $data');
    await dcumentReference.set(data, SetOptions(merge: merge));
  }

  @override
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final dcumentReference = FirebaseFirestore.instance.doc(path);
    print('set $path: $data');
    await dcumentReference.update(data);
  }

  @override
  Future<void> addDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(path);

    print('created ${collectionReference.path}: $data');
    await collectionReference.add(data);
  }

  @override
  Future<List<T>> fetchCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    final List<T> result = snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList();

    if (sort != null) {
      result.sort(sort);
    }

    return result;
  }

  @override
  Stream<List<T?>> streamCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      //
      final List<T> result = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
        return builder(snapshot.data(), snapshot.id);
      }).toList();

      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  // @override
  // Future<T> fetchQueryDocument<T>({
  //   required String path,
  //   required T Function(Map<String, dynamic> data, String id) builder,
  //   required Query Function(Query query) queryBuilder,
  // }) async {
  //   Query query = FirebaseFirestore.instance.collection(path);
  //   if (queryBuilder != null) {
  //     query = queryBuilder(query);
  //   }
  //   final QuerySnapshot snapshot = await query.limit(1).get();
  //   if (snapshot.docs.isEmpty) {
  //     return null;
  //   } else
  //     return builder(
  //         snapshot.docs?.elementAt(0)?.data(), snapshot.docs.elementAt(0).id);
  // }

  // @override
  // Stream<T> queryDocument<T>({
  //   required String path,
  //   required T Function(Map<String, dynamic> data, String id) builder,
  //   required Query Function(Query query) queryBuilder,
  // }) {
  //   Query query = FirebaseFirestore.instance.collection(path);
  //   if (queryBuilder != null) {
  //     query = queryBuilder(query);
  //   }
  //   final Stream<QuerySnapshot> snapshots = query.limit(1).snapshots();
  //   return snapshots.map(
  //     (snapshot) => builder(
  //       snapshot?.docs?.first?.data(),
  //       snapshot?.docs?.first?.id,
  //     ),
  //   );
  // }

  // @override
  // Future<void> deleteDocument({String path}) async {
  //   final reference = FirebaseFirestore.instance.doc(path);
  //   print('delete: $path');
  //   await reference.delete();
  // }
}
