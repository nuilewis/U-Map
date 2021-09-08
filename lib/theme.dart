import 'package:flutter/material.dart';
import 'constants.dart';

///Themes

///Light Theme

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
      appBarTheme: appBarTheme,
      primaryColor: cPrimaryColor,
      primaryColorLight: cPrimaryColorLight,
      accentColor: cLightGrey,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: cBlackIconColor),
      primaryIconTheme: IconThemeData(color: cBlackIconColor),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: cTextColorBlack,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(
          color: cTextColorBlack,
          fontWeight: FontWeight.normal,
        ),
        headline1: TextStyle(
            color: cTextColorBlack, fontSize: 32, fontWeight: FontWeight.bold),
        headline2: TextStyle(
            color: cTextColorBlack, fontSize: 18, fontWeight: FontWeight.bold),
      ));
}

///Dark Theme

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
      appBarTheme: appBarTheme,
      primaryColor: cPrimaryColor.withOpacity(.3),
      primaryColorLight: cPrimaryColorLight.withOpacity(.3),
      accentColor: cDarkGrey,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(),
      brightness: Brightness.dark,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: cLightIconColor),
      primaryIconTheme: IconThemeData(color: cLightIconColor),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: cTextColorWhite,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(
          color: cTextColorWhite,
          fontWeight: FontWeight.normal,
        ),
        headline1: TextStyle(
            color: cTextColorWhite, fontSize: 32, fontWeight: FontWeight.bold),
        headline2: TextStyle(
            color: cTextColorWhite, fontSize: 18, fontWeight: FontWeight.bold),
      ));
}

AppBarTheme appBarTheme = AppBarTheme(color: Colors.transparent, elevation: 0);
