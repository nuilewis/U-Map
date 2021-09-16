import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/errorscreen/firebase_error_screen.dart';
import 'package:u_map/screens/homescreen/components/umap_top_search_area.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';

import '../../size_config.dart';

class UMapSavedScreen extends StatefulWidget {
  @override
  _UMapSavedScreenState createState() => _UMapSavedScreenState();
}

class _UMapSavedScreenState extends State<UMapSavedScreen> {
  //List<UmapSaved> umapList = <UmapSaved>[];

  @override
  initState() {
    super.initState();
    initUmapSharedPreferences();
  }

  Widget buildSavedPlacesList(
    BuildContext context,
    int index,
    UmapSaved savedItem,
  ) {
    return UmapListItem(
      title: umapSPList[index].savedName,
      //markerGeopoint: document["location"],
      description: umapSPList[index].savedDescription,
      imgSrc: null,
      firstIconSvgLink: "assets/svg/trash_icon.svg",
      firstIconOnPressed: () {
        ///remove from saved list
        removeFromSavedList(
            UmapSaved(
              savedName: umapSPList[index].savedName,
              savedDescription: umapSPList[index].savedDescription,
              savedDistance: umapSPList[index].savedDistance,
              savedLocationLatitude: umapSPList[index].savedLocationLatitude,
              savedLocationLongitude: umapSPList[index].savedLocationLongitude,
            ),
            umapSPList[index].savedName);
      },

      secondIconSvgLink: "assets/svg/forward_icon.svg",
      secondIconOnPressed: () {
        LatLng markerLoc = LatLng(umapSPList[index].savedLocationLatitude,
            umapSPList[index].savedLocationLongitude);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              name: umapSPList[index].savedName,
              description: umapSPList[index].savedDescription,
              markerLocation: markerLoc,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (umapSPList.isEmpty) {
      return UmapErrorScreen(
        errorMessage: "Nothing to see here",
        errorDetails: "You haven't saved anything yet",
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              UmapTopSearchMenu(),
              Padding(
                padding: EdgeInsets.only(
                  top: getRelativeScreenHeight(context, 140),
                ),
                child: ListView.builder(
                    itemCount: umapSPList.length,
                    itemExtent: getRelativeScreenHeight(context, 190),
                    itemBuilder: (BuildContext context, int index) {
                      return buildSavedPlacesList(
                          context, index, umapSPList[index]);
                    }),
              ),
            ],
          ),
        ),

        // SizedBox(
        //   height: getRelativeScreenHeight(40),
        // ),
      );
    }
  }
}
