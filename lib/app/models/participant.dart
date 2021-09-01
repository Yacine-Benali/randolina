import 'package:randolina/app/models/client.dart';

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

  Map<String, dynamic> toMap() {
    return {};
  }
}
