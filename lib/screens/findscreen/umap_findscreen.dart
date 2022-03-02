import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umapDrawer.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/load_places.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/homescreen/components/umap_app_bar.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/size_config.dart';

class UMapFindScreen extends StatefulWidget {
  @override
  _UMapFindScreenState createState() => _UMapFindScreenState();
}

class _UMapFindScreenState extends State<UMapFindScreen> {
  List<String> category = ["administrative blocks", "classes", "offices"];

  @override
  initState() {
    super.initState();
    initUmapSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.transparent,
      appBar: UmapAppBar(),
      endDrawer: UmapDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: getRelativeScreenHeight(context, 60),
            ),

            ///Administrative blocks Stream
            Padding(
              padding: EdgeInsets.all(getRelativeScreenWidth(context, 20)),
              child: Text(
                "Administrative\nBlocks",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            LoadPlaces(category: "administrative blocks"),

            ///Offices blocks Stream
            SizedBox(
              height: getRelativeScreenHeight(context, 40),
            ),
            Padding(
              padding: EdgeInsets.all(getRelativeScreenWidth(context, 20)),
              child: Text(
                "Offices",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            LoadPlaces(category: "offices"),

            ///Classes blocks Stream
            SizedBox(
              height: getRelativeScreenHeight(context, 40),
            ),
            Padding(
              padding: EdgeInsets.all(getRelativeScreenWidth(context, 20)),
              child: Text(
                "Classes",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            LoadPlaces(category: "classes"),
            SizedBox(
              height: getRelativeScreenHeight(context, 100),
            )
          ],
        ),
      ),
    );
  }
}
