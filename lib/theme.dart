import 'package:flutter/material.dart';
import 'constants.dart';

///Themes

///Light Theme

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: cPrimaryColor,
    primaryColorLight: cPrimaryColorLight,
    primaryColorDark: cPrimaryColorDark,
    scaffoldBackgroundColor: Colors.white,
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
          color: cTextColorBlack, fontSize: 28, fontWeight: FontWeight.bold),
      headline2: TextStyle(
          color: cTextColorBlack, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    //colorScheme: ColorScheme.light().copyWith(secondary: cLightGrey),
    colorScheme: ColorScheme.light().copyWith(
      secondary: cSecondaryColor,
    ),
    cardColor: cLightGrey,
  );
}

///Dark Theme

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
      appBarTheme: appBarTheme,
      primaryColor: cPrimaryColor.withOpacity(.3),
      primaryColorLight: cPrimaryColorLight.withOpacity(.3),
      primaryColorDark: cPrimaryColorDark,
      scaffoldBackgroundColor: cBlackIconColor,
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
            color: cTextColorWhite, fontSize: 28, fontWeight: FontWeight.bold),
        headline2: TextStyle(
            color: cTextColorWhite, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      colorScheme: ColorScheme.dark().copyWith(secondary: cSecondaryColor),
      cardColor: cDarkGrey);
}

AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
  foregroundColor: Colors.transparent,
  elevation: 0,
);
