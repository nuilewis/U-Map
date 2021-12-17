import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_map/components/umap_shared_preferences/theme_model.dart';
import 'package:u_map/screens/navigationscreen/umap_navscreen.dart';
import 'package:u_map/theme.dart';
import 'components/umap_bottom_nav_bar/umap_bottom_nav_bar.dart';
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
    return ChangeNotifierProvider(
        create: (BuildContext context) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            title: 'U-Map',
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            //themeMode: ThemeMode.dark,
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,

            home: UMapBottomNavBar(),
          );
        }));
  }
}
