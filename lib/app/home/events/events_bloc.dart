import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/mini_subscriber.dart';
import 'package:randolina/app/models/participant.dart';
import 'package:randolina/app/models/saved_events.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
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

  Future<String> uploadEventProfileImage(File file, String eventId) async {
    return database.uploadFile(
      path: APIPath.eventsPictures(authUser.uid, eventId, uuid.v4()),
      filePath: file.path,
    );
  }

  Future<File> assetToFile(Asset asset) async {
    // generate random number.
    final rng = Random();
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    final File file = File('$tempPath${rng.nextInt(100)}.png');
    final ByteData byteData = await asset.getByteData();
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }

  Future<List<String>> uploadEventImages(List<Asset> images) async {
    final List<Future<String>> urls = [];
    for (final Asset asset in images) {
      final File file = await assetToFile(asset);
      final t = database.uploadFile(
        path: APIPath.eventsPictures(authUser.uid, '', uuid.v4()),
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
    return database.streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where('createdBy.id', isEqualTo: authUser.uid)
          .orderBy('createdAt', descending: true),
    );
  }

  Stream<List<Event>> getClientMyEvents() {
    return database.streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) => query.where(
        'subscribers',
        arrayContainsAny: [
          {'id': authUser.uid, 'isConfirmed': false},
          {'id': authUser.uid, 'isConfirmed': true}
        ],
      ).orderBy('createdAt', descending: true),
    );
  }

  Stream<List<Event>> getClubAllEvents() {
    //! todo @high paginate
    return database.streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.where('createdBy.id', isNotEqualTo: authUser.uid),
      sort: (a, b) => a.createdAt.compareTo(b.createdAt),
    );
  }

  Stream<List<Event>> getClientAllEvents() {
    //! todo @high paginate
    return database.streamCollection(
      path: APIPath.eventsCollection(),
      builder: (data, documentId) => Event.fromMap(data, documentId),
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
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

  List<Event> searchEvents(List<Event> events, String searchText) {
    final List<Event> matchedEvents = [];
    for (final Event event in events) {
      if (event.destination.contains(searchText)) {
        matchedEvents.add(event);
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
    if (savedEvents == null) {
      logger.severe('ERROR savedEvents should be initialized');
      return false;
    } else {
      logger.warning(savedEvents!.list.length);
    }
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final SavedEvent savedEvent = savedEvents!.list.firstWhere(
      (element) => element.eventId == event.id,
      orElse: () => SavedEvent(eventId: 'error', savedAt: Timestamp.now()),
    );
    if (savedEvent.eventId != 'error') {
      return true;
    }
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