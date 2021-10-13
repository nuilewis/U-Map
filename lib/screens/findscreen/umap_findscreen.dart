import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umapDrawer.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/homescreen/components/umap_app_bar.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/size_config.dart';

class UMapFindScreen extends StatefulWidget {
  @override
  _UMapFindScreenState createState() => _UMapFindScreenState();
}

class _UMapFindScreenState extends State<UMapFindScreen> {
  ///TODO: find a way to merge all streams to one
  final Stream<QuerySnapshot> umapAdministrativeFirestoreStream =
      FirebaseFirestore.instance
          .collection("umap_bamenda")
          .doc("umap_uba")
          .collection("administrative blocks")
          .snapshots();
  final Stream<QuerySnapshot> umapClassesFirestoreStream = FirebaseFirestore
      .instance
      .collection("umap_bamenda")
      .doc("umap_uba")
      .collection("classes")
      .snapshots();
  final Stream<QuerySnapshot> umapOfficesFirestoreStream = FirebaseFirestore
      .instance
      .collection("umap_bamenda")
      .doc("umap_uba")
      .collection("offices")
      .snapshots();
  // late final Stream<QuerySnapshot>? umapGlobalFirestoreStream;
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
      sourceLocation:
          LatLng(document["location"].latitude, document["location"].longitude),
      description: document["description"],
      imgSrc: document["imageUrl"],
      firstIconSvgLink: isSaved
          ? "assets/svg/heart_icon_filled.svg"
          : "assets/svg/heart_icon.svg",
      firstIconOnPressed: isSaved
          ? () {
              Feedback.forTap(context);
              HapticFeedback.lightImpact();
              GeoPoint sourceLocation = document["location"];
              setState(() {
                removeFromSavedList(
                    savedItem: UmapSaved(
                      savedName: document["name"],
                      savedDescription: document["description"],
                      savedImgUrl: document["imageUrl"],
                      savedLocationLatitude: sourceLocation.latitude.toDouble(),
                      savedLocationLongitude:
                          sourceLocation.latitude.toDouble(),
                    ),
                    locationName: document["name"]);
                isSaved = false;
              });
            }
          : () {
              Feedback.forTap(context);
              HapticFeedback.lightImpact();
              GeoPoint sourceLocation = document["location"];
              setState(() {
                addToSavedList(
                  savedItem: UmapSaved(
                    savedName: document["name"],
                    savedDescription: document["description"],
                    savedImgUrl: document["imageUrl"],
                    savedLocationLatitude: sourceLocation.latitude.toDouble(),
                    savedLocationLongitude: sourceLocation.longitude.toDouble(),
                  ),
                );

                isSaved = true;
              });
            },
      secondIconSvgLink: "assets/svg/forward_icon.svg",
      secondIconOnPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              name: document["name"],
              description: document["description"],
              markerLocation: LatLng(document["location"].latitude,
                  document["location"].longitude),
              imgSrc: document["imageUrl"],
            ),
          ),
        );
      },
    );
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
            ///Administrative blocks Stream
            Padding(
              padding: EdgeInsets.all(getRelativeScreenWidth(context, 20)),
              child: Text(
                "Administrative Blocks",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            StreamBuilder(
              stream: umapAdministrativeFirestoreStream,
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
                    if (umapSourceDocuments.length == 0) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Oh, there doesn't seem to be anything under this category",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemExtent: getRelativeScreenHeight(context, 195),
                          itemCount: umapSourceDocuments.length,
                          itemBuilder: (context, index) {
                            return buildPopularPlacesList(
                              context,
                              document: umapSourceDocuments[index],
                            );
                          });
                    }
                }
              },
            ),

            ///Offices blocks Stream
            SizedBox(
              height: getRelativeScreenHeight(context, 10),
            ),
            Padding(
              padding: EdgeInsets.all(getRelativeScreenWidth(context, 20)),
              child: Text(
                "Offices",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            StreamBuilder(
              stream: umapOfficesFirestoreStream,
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
                    if (umapSourceDocuments.length == 0) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Oh, there doesn't seem to be anything under this category",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemExtent: getRelativeScreenHeight(context, 195),
                        itemCount: umapSourceDocuments.length,
                        itemBuilder: (context, index) {
                          return buildPopularPlacesList(
                            context,
                            document: umapSourceDocuments[index],
                          );
                        },
                      );
                    }
                }
              },
            ),

            ///Offices blocks Stream
            SizedBox(
              height: getRelativeScreenHeight(context, 10),
            ),
            Padding(
              padding: EdgeInsets.all(getRelativeScreenWidth(context, 20)),
              child: Text(
                "Classes",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            StreamBuilder(
              stream: umapClassesFirestoreStream,
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
                    if (umapSourceDocuments.length == 0) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Oh, there doesn't seem to be anything under this category",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemExtent: getRelativeScreenHeight(context, 195),
                        itemCount: umapSourceDocuments.length,
                        itemBuilder: (context, index) {
                          return buildPopularPlacesList(
                            context,
                            document: umapSourceDocuments[index],
                          );
                        },
                      );
                    }
                }
              },
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 100),
            )
          ],
        ),
      ),
    );
  }
}
