import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';

// Future<File> fixExifRotation2(String imagePath) async {
//   final originalFile = File(imagePath);
//   List<int> imageBytes = await originalFile.readAsBytes();

//   final originalImage = img.decodeImage(imageBytes);

//   final height = originalImage.height;
//   final width = originalImage.width;

//   // Let's check for the image size
//   if (height >= width) {
//     // I'm interested in portrait photos so
//     // I'll just return here
//     return originalFile;
//   }

//   // We'll use the exif package to read exif data
//   // This is map of several exif properties
//   // Let's check 'Image Orientation'
//   final exifData = await readExifFromBytes(imageBytes);

//   img.Image fixedImage;

//   if (height < width) {
//     logger.logInfo('Rotating image necessary');
//     // rotate
//     if (exifData['Image Orientation'].printable.contains('Horizontal')) {
//       fixedImage = img.copyRotate(originalImage, 90);
//     } else if (exifData['Image Orientation'].printable.contains('180')) {
//       fixedImage = img.copyRotate(originalImage, -90);
//     } else {
//       fixedImage = img.copyRotate(originalImage, 0);
//     }
//   }

//   // Here you can select whether you'd like to save it as png
//   // or jpg with some compression
//   // I choose jpg with 100% quality
//   final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

//   return fixedFile;
// }

// Future<File> fixExifRotation(File image, {bool deleteOriginal = false}) async {
//   final Uint8List imageBytes = await image.readAsBytes();

//   final Uint8List resultBytes = await FlutterImageCompress.compressWithList(
//     imageBytes,
//     quality: 100,
//     rotate: 0,
//   );

//   final String processedImageUuid = Uuid().v4();
//   final String imageExtension = basename(image.path);

//   final tempPath = await getTemporaryDirectory();

//   final result = await ImageGallerySaver.saveImage(
//     resultBytes,
//     quality: 60,
//     name: Uuid().v1(),
//   );
//   await Future.delayed(Duration(seconds: 1));
//   // final File fixedImage = File('$tempPath/$processedImageUuid$imageExtension');
//   // if (deleteOriginal) await image.delete();
//   // await image.writeAsBytes(result);
//   // return fixedImage;
//   return File(result['filePath'].toString());
// }

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
