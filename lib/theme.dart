import 'package:flutter/material.dart';
import 'constants.dart';

///Themes

///Light Theme

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
      appBarTheme: appBarTheme,
      primaryColor: cPrimaryColor,
      accentColor: cPrimaryColorLight,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: cBlackIconColor),
      primaryIconTheme: IconThemeData(color: cBlackIconColor),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        bodyText1: TextStyle(color: cTextColorBlack),
        bodyText2: TextStyle(color: cTextColorBlack),
        headline1: TextStyle(
            color: cTextColorBlack, fontSize: 80, fontWeight: FontWeight.bold),
        headline4: TextStyle(
            color: cTextColorBlack, fontSize: 32, fontWeight: FontWeight.bold),
      ));
}

///Dark Theme

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
      appBarTheme: appBarTheme,
      primaryColor: cPrimaryColor,
      accentColor: cPrimaryColorLight,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(),
      brightness: Brightness.dark,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: cBlackIconColor),
      primaryIconTheme: IconThemeData(color: cLightIconColor),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        bodyText1: TextStyle(color: cTextColorWhite),
        bodyText2: TextStyle(color: cTextColorWhite),
        headline1: TextStyle(
            color: cTextColorWhite, fontSize: 80, fontWeight: FontWeight.bold),
        headline4: TextStyle(
            color: cTextColorWhite, fontSize: 32, fontWeight: FontWeight.bold),
      ));
}

AppBarTheme appBarTheme = AppBarTheme(color: Colors.transparent, elevation: 0);
