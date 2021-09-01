import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/utils/logger.dart';

class SavedEvents {
  SavedEvents({required this.list});
  final List<SavedEvent> list;

  factory SavedEvents.fromMap(Map<String, dynamic> data) {
    final List<String> eventsId =
        (data['eventsId'] as List<dynamic>).map((e) => e as String).toList();

    final List<Timestamp> savedAt =
        (data['savedAt'] as List<dynamic>).map((e) => e as Timestamp).toList();

    if (eventsId.length != savedAt.length) {
      logger.severe('SavedEvents Problem (savedAt.length != eventsId.length)');
      throw Exception('Unable to get saved posts');
    }

    final List<SavedEvent> list = [];
    for (var i = 0; i < eventsId.length; i++) {
      list.add(
        SavedEvent(
          eventId: eventsId.elementAt(i),
          savedAt: savedAt.elementAt(i),
        ),
      );
    }

    return SavedEvents(
      list: list,
    );
  }
}

class SavedEvent {
  SavedEvent({
    required this.eventId,
    required this.savedAt,
  });

  final String eventId;
  final Timestamp savedAt;
}
