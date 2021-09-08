import 'package:flutter/material.dart';
import 'package:u_map/screens/homescreen/components/umap_maps.dart';
import 'package:u_map/screens/homescreen/components/umap_top_search_area.dart';
import 'package:u_map/size_config.dart';
import 'components/umap_popular_places.dart';

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
            UmapMaps(),
            UmapTopSearchMenu(),
            PopularPlaces(),
          ],
        ),
      ),
    );
  }
}
