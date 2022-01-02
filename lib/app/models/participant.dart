import 'package:randolina/app/models/mini_subscriber.dart';
import 'package:randolina/app/models/user.dart';

class Participant {
  Participant({
    required this.client,
    required this.isConfirmed,
  });

  final User client;
  bool isConfirmed;
  factory Participant.fromMap(User client, {required bool isConfirmed}) {
    return Participant(
      client: client,
      isConfirmed: isConfirmed,
    );
  }

  MiniSubscriber toMiniSubscriber() {
    return MiniSubscriber(id: client.id, isConfirmed: isConfirmed);
  }
}
