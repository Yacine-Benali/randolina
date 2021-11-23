import 'dart:async';

import 'package:randolina/app/models/subscription.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:tuple/tuple.dart';

class SubBloc {
  final Database database;

  SubBloc({required this.database});

  Stream<List<Tuple2<Subscription, User>>> getUnApporvedUsers() {
    final Stream<List<Subscription>> unApprovedIdsStream =
        database.streamCollection(
      path: 'subscriptions',
      builder: (data, id) => Subscription.fromMap(data, id),
      queryBuilder: (query) => query.where('isApproved', isEqualTo: true),
    );

    final Stream<List<Tuple2<Subscription, User>>> result =
        unApprovedIdsStream.transform(
      StreamTransformer.fromHandlers(handleData:
          (List<Subscription> subscriptionsList, EventSink output) async {
        final List<Future<Tuple2<Subscription, User>?>> a =
            subscriptionsList.map((subscriber) async {
          final User? user = await database.fetchDocument(
            path: APIPath.userDocument(subscriber.id),
            builder: (data, id) => User.fromMap2(data, id),
          );
          if (user != null) {
            return Tuple2(subscriber, user);
          } else {
            return null;
          }
        }).toList();
        final List<Tuple2<Subscription, User>?> b = await Future.wait(a);
        final List<Tuple2<Subscription, User>> c =
            b.whereType<Tuple2<Subscription, User>>().toList();

        output.add(c);
      }),
    );

    return result;
  }

  Future<void> saveSubscription(Subscription subscription) async {
    await database.updateData(
      path: APIPath.subscriptionsDocument(subscription.id),
      data: subscription.toMap(),
    );
  }
}
