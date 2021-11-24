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
          .doc("umap_uba_ref")
          .collection("administrative blocks")
          .snapshots();
  final Stream<QuerySnapshot> umapClassesFirestoreStream = FirebaseFirestore
      .instance
      .collection("umap_bamenda")
      .doc("umap_uba_ref")
      .collection("classes")
      .snapshots();
  final Stream<QuerySnapshot> umapOfficesFirestoreStream = FirebaseFirestore
      .instance
      .collection("umap_bamenda")
      .doc("umap_uba_ref")
      .collection("offices")
      .snapshots();
  // late final Stream<QuerySnapshot>? umapGlobalFirestoreStream;
  List<String> category = ["administrative blocks", "classes", "offices"];
  late LatLng markerLoc;
  String? savedIconLink;
  late VoidCallback onSavedPressed;
  List<bool> isSaved = [];
  double? calcDistance;

  @override
  initState() {
    super.initState();
    initUmapSharedPreferences();
  }

  Widget buildPlacesList(BuildContext context,
      {required DocumentSnapshot document,
      required String category,
      required int index}) {
    for (int i = 0; i < umapSPList.length; i++) {
      ///Check if is saved
      if (umapSPList[i].savedName == document["name"]) {
        isSaved[index] = true;
      }
    }
    return UmapListItem(
      title: document["name"][index],
      description: document["description"][index],
      imgSrc: document["imageUrl"][index],
      firstIconSvgLink: isSaved[index]
          ? "assets/svg/heart_icon_filled.svg"
          : "assets/svg/heart_icon.svg",
      firstIconOnPressed: isSaved[index]
          ? () {
              Feedback.forTap(context);
              HapticFeedback.lightImpact();
              setState(() {
                removeFromSavedList(
                    savedItem: UmapSaved(
                      savedCategory: category,
                      savedName: document["name"][index],
                      savedID: document["id"][index],
                      savedDescription: document["description"][index],
                      savedImgUrl: document["imageUrl"][index],
                    ),
                    locationID: document.id);
                isSaved[index] = false;
              });
            }
          : () {
              Feedback.forTap(context);
              HapticFeedback.lightImpact();
              setState(() {
                addToSavedList(
                  savedItem: UmapSaved(
                    savedCategory: category,
                    savedName: document["name"][index],
                    savedID: document["id"][index],
                    savedDescription: document["description"][index],
                    savedImgUrl: document["imageUrl"][index],
                  ),
                );

                isSaved[index] = true;
              });
            },
      secondIconSvgLink: "assets/svg/forward_icon.svg",
      secondIconOnPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              category: category,
              imgSrc: document["imageUrl"][index],
              documentID: document["id"][index],
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
                    DocumentSnapshot umapSourceDocuments =
                        snapshot.data!.docs[0];

                    ///Index of 0 because there is only 1 document in the collection

                    if (umapSourceDocuments["id"].isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Oh, we can't find anything under this category",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemExtent: getRelativeScreenHeight(context, 195),
                          itemCount: umapSourceDocuments["id"].length,
                          itemBuilder: (context, index) {
                            isSaved.add(false);

                            return buildPlacesList(context,
                                document: umapSourceDocuments,
                                index: index,
                                category: "administrative blocks");
                          });
                    }
                }
              },
            ),

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
                    DocumentSnapshot umapSourceDocuments =
                        snapshot.data!.docs[0];
                    if (umapSourceDocuments["id"].isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Oh, there doesn't seem to be anything under this category",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemExtent: getRelativeScreenHeight(context, 195),
                        itemCount: umapSourceDocuments["id"].length,
                        itemBuilder: (context, index) {
                          isSaved.add(false);

                          return buildPlacesList(context,
                              index: index,
                              document: umapSourceDocuments,
                              category: "offices");
                        },
                      );
                    }
                }
              },
            ),

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
                    DocumentSnapshot umapSourceDocuments =
                        snapshot.data!.docs[0];

                    ///Because there is only 1 document in the collection
                    if (umapSourceDocuments["id"].isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Oh, there doesn't seem to be anything under this category",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemExtent: getRelativeScreenHeight(context, 195),
                        itemCount: umapSourceDocuments["id"].length,
                        itemBuilder: (context, index) {
                          isSaved.add(false);

                          return buildPlacesList(context,
                              index: index,
                              document: umapSourceDocuments,
                              category: "classes");
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
