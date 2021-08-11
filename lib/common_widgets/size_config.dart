import 'package:flutter/widgets.dart';

// ignore: avoid_classes_with_only_static_members
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  // for dealing witch notches
  // static late double _safeAreaHorizontal;
  // static late double _safeAreaVertical;
  // static late double safeBlockHorizontal;
  // static late double safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    // _safeAreaHorizontal =
    //     _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    // _safeAreaVertical =
    //     _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    // safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    // safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  @override
  String toString() {
    return '''
    screenHeight: $screenHeight
    screenWidth: $screenWidth
    safeBlockHorizontal: $blockSizeHorizontal
    safeBlockVertical: $blockSizeVertical
    ''';
  }
}
