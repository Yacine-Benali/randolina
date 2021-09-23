import 'package:randolina/app/home_admin/sites/site.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

class SitesBloc {
  SitesBloc({required this.database});

  final Database database;

  Future<void> createSite(Site site) async {
    database.setData(
      path: APIPath.sitesDocument(site.id),
      data: site.toMap(),
    );
  }

  Future<void> deleteSite(Site site) async {
    database.deleteDocument(path: APIPath.sitesDocument(site.id));
  }

  Stream<List<Site>> getSites() {
    return database.streamCollection(
      path: APIPath.sitesCollection(),
      builder: (data, id) => Site.fromMap(data, id),
    );
  }
}
