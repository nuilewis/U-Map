import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/homescreen/components/umap_top_search_area.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/size_config.dart';

class UMapFindScreen extends StatefulWidget {
  @override
  _UMapFindScreenState createState() => _UMapFindScreenState();
}

class _UMapFindScreenState extends State<UMapFindScreen> {
  final Stream<QuerySnapshot> umapFirestoreStream =
      FirebaseFirestore.instance.collection('umap_uba').snapshots();
  late LatLng markerLoc;
  String? savedIconLink;
  late VoidCallback onSavedPressed;
  bool isSaved = false;
  double? calcDistance;

  @override
  initState() {
    super.initState();
    initUmapSharedPreferences();
  }

  Widget buildPopularPlacesList(
    BuildContext context, {
    required DocumentSnapshot document,
  }) {
    for (int i = 0; i < umapSPList.length; i++) {
      ///Check if is saved
      if (umapSPList[i].savedName == document["name"]) {
        isSaved = true;
      }
    }
    return UmapListItem(
      title: document["name"],
      //markerGeopoint: document["location"],
      description: document["description"],
      imgSrc: null,
      firstIconSvgLink: isSaved
          ? "assets/svg/heart_icon_filled.svg"
          : "assets/svg/heart_icon.svg",
      firstIconOnPressed: isSaved
          ? () {
              Feedback.forTap(context);
              GeoPoint sourceLocation = document["location"];
              setState(() {
                removeFromSavedList(
                    UmapSaved(
                      savedName: document["name"],
                      savedDescription: document["description"],
                      // savedDistance: calcDistance!.toStringAsFixed(2),
                      savedDistance: "1km",
                      savedLocationLatitude: sourceLocation.latitude.toDouble(),
                      savedLocationLongitude:
                          sourceLocation.latitude.toDouble(),
                    ),
                    document["name"]);
                isSaved = false;
              });
            }
          : () {
              Feedback.forTap(context);
              GeoPoint sourceLocation = document["location"];
              setState(() {
                addToSavedList(
                  UmapSaved(
                    savedName: document["name"],
                    savedDescription: document["description"],

                    ///Todo: Replace Saved Distance with actual Saved distance
                    // savedDistance: calcDistance!.toStringAsFixed(2),
                    savedDistance: "1km",
                    savedLocationLatitude: sourceLocation.latitude.toDouble(),
                    savedLocationLongitude: sourceLocation.longitude.toDouble(),
                  ),
                );
                isSaved = true;
              });
            },

      secondIconSvgLink: "assets/svg/forward_icon.svg",
      secondIconOnPressed: () {
        markerLoc = LatLng(
            document["location"].latitude, document["location"].longitude);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              name: document["name"],
              description: document["description"],
              markerLocation: markerLoc,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            UmapTopSearchMenu(),
            Padding(
              padding: EdgeInsets.only(
                top: getRelativeScreenHeight(context, 140),
              ),
              child: StreamBuilder(
                stream: umapFirestoreStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).iconTheme.color!,
                          ),
                        ),
                      );
                    default:
                      List<DocumentSnapshot> umapSourceDocuments =
                          snapshot.data!.docs;
                      return ListView.builder(
                          itemExtent: getRelativeScreenHeight(context, 195),
                          itemCount: umapSourceDocuments.length,
                          itemBuilder: (context, index) {
                            //Loop to check if a location has already been saved or not

                            // for (int i = 0; i < umapSPList.length; i++) {
                            //   if (umapSPList[i].savedName ==
                            //       umapSourceDocuments[index]["name"]) {
                            //     savedIconLink =
                            //         "assets/svg/heart_icon_filled.svg";
                            //     onSavedPressed = () {
                            //       GeoPoint sourceLocation =
                            //           umapSourceDocuments[index]["location"];
                            //       removeFromSavedList(
                            //           UmapSaved(
                            //             savedName: umapSourceDocuments[index]
                            //                 ["name"],
                            //             savedDescription:
                            //                 umapSourceDocuments[index]
                            //                     ["description"],
                            //
                            //             ///Todo: Replace Saved Distance with actual Saved distance
                            //             savedDistance: "1.23km",
                            //             savedTapLocationLatitude:
                            //                 sourceLocation.latitude.toDouble(),
                            //             savedTapLocationLongitude:
                            //                 sourceLocation.longitude.toDouble(),
                            //           ),
                            //           umapSourceDocuments[index]["name"]);
                            //     };
                            //   } else {
                            //     savedIconLink = "assets/svg/heart_icon.svg";
                            //     onSavedPressed = () {
                            //       GeoPoint sourceLocation =
                            //           umapSourceDocuments[index]["location"];
                            //       addToSavedList(
                            //         UmapSaved(
                            //           savedName: umapSourceDocuments[index]
                            //               ["name"],
                            //           savedDescription:
                            //               umapSourceDocuments[index]
                            //                   ["description"],
                            //
                            //           ///Todo: Replace Saved Distance with actual Saved distance
                            //           savedDistance: "1.23km",
                            //           savedTapLocationLatitude:
                            //               sourceLocation.latitude.toDouble(),
                            //           savedTapLocationLongitude:
                            //               sourceLocation.longitude.toDouble(),
                            //         ),
                            //       );
                            //     };
                            //   }
                            // }
                            return buildPopularPlacesList(
                              context,
                              document: umapSourceDocuments[index],
                            );
                          });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
