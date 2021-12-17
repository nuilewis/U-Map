import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/constants.dart';
import 'package:u_map/screens/findscreen/umap_findscreen.dart';
import 'package:u_map/screens/homescreen/umap_homescreen.dart';
import 'package:u_map/screens/savedscreen/umap_savedscreen.dart';
import 'package:u_map/size_config.dart';

class UMapBottomNavBar extends StatefulWidget {
  const UMapBottomNavBar({Key? key}) : super(key: key);

  @override
  _UMapBottomNavBarState createState() => _UMapBottomNavBarState();
}

class _UMapBottomNavBarState extends State<UMapBottomNavBar> {
  int currentPageIndex = 0;
  Color menuItemBgColor = Colors.transparent;
  List<bool> onMenuclicked = [true, false, false];
  Color menuBgGradientTransColor = Color(0x00FFFFF);

  final List<Widget> _pageList = [
    UMapHomeScreen(),
    UMapFindScreen(),
    UMapSavedScreen(),
  ];

  final List<String> _iconLinkList = [
    "assets/svg/home_icon.svg",
    "assets/svg/search_icon.svg",
    "assets/svg/heart_icon.svg",
  ];
  @override
  Widget build(BuildContext context) {
    ///Todo: fix this
    if (Theme.of(context).scaffoldBackgroundColor == Colors.white) {
      menuBgGradientTransColor = Color(0xFFFFFF);
    } else {
      menuBgGradientTransColor = Color(0x000000);
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _pageList[currentPageIndex],
      bottomNavigationBar: Material(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).scaffoldBackgroundColor,
                menuBgGradientTransColor
              ], stops: [
                0.4,
                1
              ], end: Alignment.topCenter, begin: Alignment.bottomCenter),
            ),
            height: getRelativeScreenHeight(context, 100),
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                vertical: getRelativeScreenHeight(context, 15)),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemExtent: MediaQuery.of(context).size.width / 4,
              scrollDirection: Axis.horizontal,
              itemCount: _pageList.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      Feedback.forTap(context);
                      HapticFeedback.lightImpact();
                      currentPageIndex = i;
                      onMenuclicked = [false, false, false];
                      onMenuclicked[i] = true;

                      // iconBgSize = [0, 0, 0];
                      // iconBgSize[i] = getRelativeScreenWidth(context, 60);
                    });
                  },
                  child: UmapBottomNavBarItem(
                    iconLink: _iconLinkList[i],
                    onClicked: onMenuclicked[i],
                  ),
                );
              },
            )),
      ),
    );
  }
}

class UmapBottomNavBarItem extends StatelessWidget {
  const UmapBottomNavBarItem({
    Key? key,
    required this.iconLink,
    required this.onClicked,
  }) : super(key: key);

  //final VoidCallback onPressed;
  final String iconLink;
  final bool onClicked;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      AnimatedContainer(
        width: onClicked ? getRelativeScreenWidth(context, 50) : 0,
        height: onClicked ? getRelativeScreenWidth(context, 50) : 0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(getRelativeScreenWidth(context, 20)),
          color: cPrimaryColor,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(getRelativeScreenWidth(context, 20)),
        child: SvgPicture.asset(
          iconLink,
          color: Theme.of(context).iconTheme.color,
        ),
      )
    ]);
  }
}
