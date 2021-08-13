import 'package:algolia/algolia.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/main.dart';

class AlgoliaService {
  AlgoliaService._privateConstructor();

  static final AlgoliaService instance = AlgoliaService._privateConstructor();

  final Algolia _algolia = Algolia.init(
    applicationId: '62PH99K08I',
    apiKey: '54b7a05d2436700ff62387b5835c2798',
  );

  AlgoliaIndexReference get _moviesIndex => _algolia.instance.index(userIndex);

  Future<List<MiniUser>> performUserQuery({required String text}) async {
    final query = _moviesIndex.query(text);
    final snap = await query.getObjects();
    final users = snap.hits.map((f) {
      f.data['id'] = f.objectID;
      return MiniUser.fromMap(f.data);
    }).toList();
    return users;
  }
}
