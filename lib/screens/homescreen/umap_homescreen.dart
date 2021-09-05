import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:u_map/size_config.dart';

import 'components/umap_popular_places.dart';
import 'components/umap_searchbar.dart';

class UMapHomeScreen extends StatefulWidget {
  @override
  _UMapHomeScreenState createState() => _UMapHomeScreenState();
}

class _UMapHomeScreenState extends State<UMapHomeScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.white70,
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: SvgPicture.asset(
      //         "assets/svg/menu_icon.svg",
      //         color: Theme.of(context).iconTheme.color,
      //       ),
      //       onPressed: () {},
      //       //color: Theme.of(context).iconTheme.color,
      //     ),
      //   ],
      // ),

      body: SafeArea(
        child: Stack(
          children: [
            PopularPlaces(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                getRelativeScreenWidth(20),
                getRelativeScreenHeight(60),
                getRelativeScreenWidth(15),
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UMapSearchBar(),
                  SizedBox(
                    width: getRelativeScreenWidth(20),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/svg/menu_icon.svg",
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
