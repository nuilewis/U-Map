import 'package:flutter/material.dart';
import 'package:u_map/theme.dart';

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
      //theme: darkThemeData(context),

      debugShowCheckedModeBanner: false,
      darkTheme: darkThemeData(context),
      home: UMapHomeScreen(),
    );
  }
}

class UMapHomeScreen extends StatefulWidget {
  @override
  _UMapHomeScreenState createState() => _UMapHomeScreenState();
}

class _UMapHomeScreenState extends State<UMapHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Text(
          'This is text',
        ),
      ),
    );
  }
}
