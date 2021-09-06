import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FilteredImageConverter {
  static Future<File?> convert({required GlobalKey globalKey}) async {
    final RenderObject? renderObject =
        globalKey.currentContext?.findRenderObject();

    if (renderObject != null) {
      final RenderRepaintBoundary repaintBoundary =
          renderObject as RenderRepaintBoundary;
      final ui.Image boxImage = await repaintBoundary.toImage();
      final ByteData? byteData =
          await boxImage.toByteData(format: ui.ImageByteFormat.png);

      final String tempPath = (await getTemporaryDirectory()).path;
      final File file = File('$tempPath/${Timestamp.now().toString()}.png');

      if (byteData != null) {
        await file.writeAsBytes(byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ));

        return file;
      }
    }
    return null;
  }
}
