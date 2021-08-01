import 'package:randolina/app/models/client.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

class ClientProfileBloc {
  ClientProfileBloc({
    required this.database,
    required this.client,
  });
  final Database database;
  final Client client;

  Future<void> saveChanges(String? bio, String activity) async {
    await database.setData(
      path: APIPath.userDocument(client.id),
      data: {
        'bio': bio,
        'activity': activity,
      },
    );
  }
}
