import 'package:flutter/material.dart';
import 'package:u_map/screens/findscreen/umap_findscreen.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/theme.dart';
import 'screens/homescreen/umap_homescreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      themeMode: ThemeMode.light,
      //themeMode: ThemeMode.dark,

      debugShowCheckedModeBanner: false,

      home: UMapHomeScreen(),
      //home: UMapFindScreen(),
      //home: UmapLocationDetails(),
    );
  }
}
