import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

class ModeratorsBloc {
  final Database database;

  ModeratorsBloc({required this.database});

  Stream<List<User>> getModeratorsList() {
    return database.streamCollection(
      path: APIPath.usersCollection(),
      queryBuilder: (query) => query.where('isModerator', isEqualTo: true),
      builder: (data, id) => User.fromMap(data, id),
    );
  }

  Future<void> makeUserMod(MiniUser miniUser, {required bool isMod}) async {
    return database.updateData(
        path: APIPath.userDocument(miniUser.id), data: {'isModerator': isMod});
  }
}
