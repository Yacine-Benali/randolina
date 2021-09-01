import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/mini_subscriber.dart';

class Participant {
  Participant({
    required this.client,
    required this.isConfirmed,
  });

  final Client client;
  bool isConfirmed;
  factory Participant.fromMap(Client client, {required bool isConfirmed}) {
    return Participant(
      client: client,
      isConfirmed: isConfirmed,
    );
  }

  MiniSubscriber toMiniSubscriber() {
    return MiniSubscriber(id: client.id, isConfirmed: isConfirmed);
  }
}
