import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  MediaQueryData? _mediaQueryData;
  late double screenWidth;
  late double screenHeight;
  late Orientation orientation;

  init(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

double getRelativeScreenHeight(BuildContext context, double inputHeight) {
  MediaQueryData _mediaQueryData = MediaQuery.of(context);
  double screenHeight = _mediaQueryData.size.height;
  //Takes in your screen height and rationalises it to the height
  // of an iphone 11.
  // because the design was designed for an iphone 11 ie 896.0
  return (inputHeight / 812.0) * screenHeight;
}

double getRelativeScreenWidth(BuildContext context, double inputWidth) {
  MediaQueryData _mediaQueryData = MediaQuery.of(context);
  double screenWidth = _mediaQueryData.size.width;

  //Takes in your screen height and rationalises it to the width
  // of an iphone 11.
  // because the design was designed for an iphone 11 ie 375
  return (inputWidth / 375.0) * screenWidth;
}
