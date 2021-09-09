import 'package:flutter/material.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/homescreen/components/umap_top_search_area.dart';

import '../../size_config.dart';

class UMapSavedScreen extends StatefulWidget {
  @override
  _UMapSavedScreenState createState() => _UMapSavedScreenState();
}

class _UMapSavedScreenState extends State<UMapSavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            UmapTopSearchMenu(),
            SizedBox(
              height: getRelativeScreenHeight(context, 30),
            ),
            UmapListItem(
              title: "The Central Administration",
              description: "description of the central admin",
              imgSrc: null,
              firstIconSvgLink: "assets/svg/heart_icon.svg",
              firstIconOnPressed: () {},
              secondIconSvgLink: "assets/svg/forward_icon.svg",
              secondIconOnPressed: () {},
            )

            // SizedBox(
            //   height: getRelativeScreenHeight(40),
            // ),
          ],
        ),
      ),
    );
  }
}
