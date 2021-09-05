import 'package:flutter/material.dart';
import 'package:u_map/theme.dart';

import 'screens/homescreen/umap_homescreen.dart';

void main() {
  runApp(UMap());
}

class UMap extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      //theme: darkThemeData(context),

      debugShowCheckedModeBanner: false,

      home: UMapHomeScreen(),
    );
  }
}
