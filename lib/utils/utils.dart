import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';

String calculateGroupeChatId(String user1, String user2) {
  String groupChatId;

  if (user2.hashCode <= user1.hashCode) {
    groupChatId = '$user2-$user1';
  } else {
    groupChatId = '$user1-$user2';
  }
  return groupChatId;
}

String eventDateFormat(DateTime date) {
  final DateFormat formatter = DateFormat('dd MMM yyyy – kk:mm');
  return formatter.format(date);
}

String eventCardDateFormat(Timestamp date) {
  final DateTime tempDay2 = date.toDate();
  final DateFormat formatter = DateFormat('dd LLL');
  final String formatted = formatter.format(tempDay2);
  return formatted;
}

String particpantDateFormmater(Timestamp date) {
  final DateTime tempDay2 = date.toDate();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String formatted = formatter.format(tempDay2);
  return formatted;
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
