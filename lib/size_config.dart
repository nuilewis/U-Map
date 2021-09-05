import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

double getRelativeScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;

  //Takes in your screen height and rationalises it to the height
  // of an iphone 11.
  // because the design was designed for an iphone 11 ie 896.0
  return (inputHeight / 812.0) * screenHeight;
}

double getRelativeScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;

  //Takes in your screen height and rationalises it to the height
  // of an iphone 11.
  // because the design was designed for an iphone 11 ie 896.0
  return (inputWidth / 375.0) * screenWidth;
}
