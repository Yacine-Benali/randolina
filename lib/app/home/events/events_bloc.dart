import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/home/events/widgets/events_search.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/mini_subscriber.dart';
import 'package:randolina/app/models/participant.dart';
import 'package:randolina/app/models/saved_events.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:uuid/uuid.dart';

class EventsBloc {
  EventsBloc({
    required this.database,
    required this.authUser,
  });

  final Database database;
  final AuthUser authUser;
  final Uuid uuid = Uuid();
  SavedEvents? savedEvents;
  final testDate =
      Timestamp.fromDate(DateTime.now().subtract(Duration(days: 365)));

  Future<String> uploadEventProfileImage(File file, String eventId) async {
    return database.uploadFile(
      path: APIPath.eventsFiles(authUser.uid, eventId, uuid.v4()),
      filePath: file.path,
    );
  }

  Future<List<String>> uploadEventImages(List<File> images) async {
    final List<Future<String>> urls = [];
    for (final File file in images) {
      final t = database.uploadFile(
        path: APIPath.eventsFiles(authUser.uid, '', uuid.v4()),
        filePath: file.path,
      );
      urls.add(t);
    }
    return Future.wait(urls);
  }

  Future<void> saveEvent(Event event) async => database.setData(
        path: APIPath.eventDocument(event.id),
        data: event.toMap(),
      );

  Stream<List<Event>> getClubMyEvents() {
    final enddate = Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));
    return database.streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where('createdBy.id', isEqualTo: authUser.uid)
          .where('endDateTime', isGreaterThan: enddate),
      sort: (Event a, Event b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Stream<List<Event>> getClubAllEvents() {
    final enddate = Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));
    //! TODO @high paginate, combine allevents
    //! only show myevents from all events
    return database
        .streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.where('endDateTime', isGreaterThan: enddate),
      sort: (Event a, Event b) => a.createdAt.compareTo(b.createdAt) * -1,
    )
        .map((events) {
      return events.where((event) {
        return event.createdBy.id != authUser.uid;
      }).toList();
    });
  }

  Stream<List<Event>> getClientMyEvents() {
    final enddate = Timestamp.fromDate(DateTime.now());

    return database.streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) => query.where(
        'subscribers',
        arrayContainsAny: [
          {'id': authUser.uid, 'isConfirmed': false},
          {'id': authUser.uid, 'isConfirmed': true}
        ],
      ).where('endDateTime', isGreaterThan: enddate),
      sort: (Event a, Event b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Stream<List<Event>> getClientAllEvents() {
    final enddate = Timestamp.fromDate(DateTime.now());

    //! TODO @high paginate
    return database.streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.where('endDateTime', isGreaterThan: enddate),
      sort: (Event a, Event b) => a.createdAt.compareTo(b.createdAt) * -1,
    );
  }

  Future<void> deleteEvent(Event event) async =>
      database.deleteDocument(path: APIPath.eventDocument(event.id));

  Future<void> subscribeToEvent(Event event) async {
    final miniSubscriber = MiniSubscriber(id: authUser.uid, isConfirmed: false);
    await database.updateData(
      path: APIPath.eventDocument(event.id),
      data: {
        'subscribers': FieldValue.arrayUnion([miniSubscriber.toMap()])
      },
    );
  }

  Future<void> unsubscribeFromEvent(Event event) async {
    late final MiniSubscriber miniSubscriber;

    for (final MiniSubscriber temp in event.subscribers) {
      if (temp.id == authUser.uid) {
        miniSubscriber = temp;
      }
    }
    await database.updateData(
      path: APIPath.eventDocument(event.id),
      data: {
        'subscribers': FieldValue.arrayRemove([miniSubscriber.toMap()])
      },
    );
  }

  List<Event> eventsTextSearch(
    List<Event> events,
    String searchText,
    int searchWilaya,
  ) {
    final List<Event> matchedEvents = [];
    for (final Event event in events) {
      if (searchWilaya == 0) {
        if (event.destination
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          matchedEvents.add(event);
        }
      } else {
        if (event.destination
                .toLowerCase()
                .contains(searchText.toLowerCase()) &&
            event.wilaya == searchWilaya) {
          matchedEvents.add(event);
        }
      }
    }
    return matchedEvents;
  }

  List<Event> filtreEvents(
    List<Event> events,
    String searchText,
    EventCreatedBy eventCreatedBy,
    SfRangeValues sfRangeValues,
  ) {
    final List<Event> matchedEvents = [];

    for (final Event event in events) {
      if (event.destination.toLowerCase().contains(searchText.toLowerCase()) &&
          (event.price >= (sfRangeValues.start as num).toInt()) &&
          event.price <= (sfRangeValues.end as num).toInt()) {
        if (eventCreatedBy == EventCreatedBy.clubOnly &&
            event.createdByType == 1) {
          matchedEvents.add(event);
        } else if (eventCreatedBy == EventCreatedBy.agencyOnly &&
            event.createdByType == 2) {
          matchedEvents.add(event);
        } else if (eventCreatedBy == EventCreatedBy.both) {
          matchedEvents.add(event);
        }
      }
    }
    return matchedEvents;
  }

  Future<void> getSavedEvents() async {
    final SavedEvents? savedEvents = await database.fetchDocument(
      path: APIPath.savedEventDocument(authUser.uid),
      builder: (data, id) => SavedEvents.fromMap(data),
    );
    this.savedEvents = savedEvents;
  }

  Future<void> saveEventToFavorite(Event event) async {
    await database.setData(
      path: APIPath.savedEventDocument(authUser.uid),
      data: {
        'eventsId': FieldValue.arrayUnion([event.id]),
        'savedAt': FieldValue.arrayUnion([Timestamp.now()])
      },
    );
    await getSavedEvents();
  }

  Future<void> unsaveEventFromFavorite(Event event) async {
    if (savedEvents != null) {
      final SavedEvent savedEvent = savedEvents!.list
          .firstWhere((element) => element.eventId == event.id);
      await database.setData(
        path: APIPath.savedEventDocument(authUser.uid),
        data: {
          'eventsId': FieldValue.arrayRemove([savedEvent.eventId]),
          'savedAt': FieldValue.arrayRemove([savedEvent.savedAt])
        },
      );
    }
    await getSavedEvents();
  }

  bool isEventSaved(Event event) {
    // if (savedEvents == null) {
    //   logger.severe('ERROR savedEvents should be initialized');
    //   return false;
    // } else {
    //   logger.warning(savedEvents!.list.length);
    // }
    // // ignore: unnecessary_nullable_for_final_variable_declarations
    // final SavedEvent savedEvent = savedEvents!.list.firstWhere(
    //   (element) => element.eventId == event.id,
    //   orElse: () => SavedEvent(eventId: 'error', savedAt: Timestamp.now()),
    // );
    // if (savedEvent.eventId != 'error') {
    //   return true;
    // }
    return false;
  }

  Future<List<Participant>> getEventParticipant(Event event) async {
    final List<String> userIds = event.subscribers.map((e) => e.id).toList();

    final List<Future<Client?>> futures = [];

    for (final String id in userIds) {
      final Future<Client?> futureClient = database.fetchDocument(
        path: APIPath.userDocument(id),
        builder: (data, id) => Client.fromMap(data, id),
      );
      futures.add(futureClient);
    }

    final List<Client?> dirtyClient = await Future.wait(futures);

    final List<Participant> participants = [];
    for (final MiniSubscriber miniSubscriber in event.subscribers) {
      for (final Client? client in dirtyClient) {
        if (client != null) {
          if (miniSubscriber.id == client.id) {
            final p = Participant(
              client: client,
              isConfirmed: miniSubscriber.isConfirmed,
            );
            participants.add(p);
          }
        }
      }
    }
    return participants;
  }

  Future<void> saveParticipants(
      List<Participant> participants, Event event) async {
    await database.setData(
      path: APIPath.eventDocument(event.id),
      data: {
        'subscribers':
            participants.map((e) => e.toMiniSubscriber().toMap()).toList()
      },
    );
  }
}
