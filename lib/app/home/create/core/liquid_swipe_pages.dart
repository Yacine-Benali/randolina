import 'dart:io';

import 'package:flutter/material.dart';

import './filters.dart';

class LiquidSwipePagesService {
  static List<Container> getImageFilteredPaged({
    required File imageFile,
    required double height,
    required double width,
  }) {
    final Image image = Image.file(
      imageFile,
      fit: BoxFit.cover,
    );

    final List<Container> pages = [];

    for (final Filter filter in filters) {
      // ignore: sized_box_for_whitespace
      final Container colorFilterPage = Container(
        height: height,
        width: width,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(filter.matrixValues),
          child: image,
        ),
      );
      pages.add(colorFilterPage);
    }
    return pages;
  }
}
