import 'dart:async';

import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

class ApprovedBloc {
  ApprovedBloc({required this.database});

  final Database database;

  Stream<List<User>> getUnApporvedUsers() {
    final Stream<List<String>> unApprovedIdsStream = database.streamCollection(
      path: 'subscriptions',
      builder: (data, id) => id,
      queryBuilder: (query) => query.where('isApproved', isEqualTo: false),
    );

    final Stream<List<User>> result = unApprovedIdsStream.transform(
      StreamTransformer.fromHandlers(
          handleData: (List<String> event, EventSink output) async {
        final List<Future<User?>> a = event.map((userId) async {
          return database.fetchDocument(
            path: APIPath.userDocument(userId),
            builder: (data, id) => User.fromMap2(data, id),
          );
        }).toList();
        final List<User?> b = await Future.wait(a);
        final List<User> c = b.whereType<User>().toList();

        output.add(c);
      }),
    );
    return result;
  }
}
