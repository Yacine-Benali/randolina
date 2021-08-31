import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:uuid/uuid.dart';

class EventsBloc {
  EventsBloc({
    required this.database,
    required this.authUser,
  });

  final Database database;
  final AuthUser authUser;
  final Uuid uuid = Uuid();

  Future<String> uploadEventProfileImage(File file, String eventId) async {
    return database.uploadFile(
      path: APIPath.eventsPictures(authUser.uid, eventId, uuid.v4()),
      filePath: file.path,
    );
  }

  Future<File> assetToFile(Asset asset) async {
    // generate random number.
    final rng = Random();
    // get temporary directory of device.
    final Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    final String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    final File file = File('$tempPath${rng.nextInt(100)}.png');
    final ByteData byteData = await asset.getByteData();
    // write bodyBytes received in response to file.
    await file.writeAsBytes(byteData.buffer.asUint8List());
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
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

  Future<void> saveEvent(String eventId, Event event) async => database.setData(
      path: APIPath.eventDocument(eventId), data: event.toMap());
}
