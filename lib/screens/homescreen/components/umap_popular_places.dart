import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/homescreen/components/popular_places_list_item.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/size_config.dart';

class PopularPlaces extends StatefulWidget {
  @override
  State<PopularPlaces> createState() => _PopularPlacesState();
}

class _PopularPlacesState extends State<PopularPlaces> {
  final Stream<QuerySnapshot> umapFirestoreStream = FirebaseFirestore.instance
      .collection("umap_bamenda")
      .doc("umap_uba_ref")
      .collection("administrative blocks")
      .snapshots();

  late final LatLng markerLoc;
  bool isSaved = false;

  @override
  initState() {
    super.initState();
    initUmapSharedPreferences();
  }

  Widget buildPopularPlacesList(
      {required BuildContext context,
      required DocumentSnapshot document,
      required int index,
      required String category}) {
    ///Todo: Add code to find the most popular locations
    return PopularPlacesListItem(
      title: document["name"][index],
      //markerGeopoint: document["location"][index],
      imageSrc: document["imageUrl"][index],
      saveIconLink: isSaved
          ? "assets/svg/heart_icon_filled.svg"
          : "assets/svg/heart_icon.svg",
      onSavedPressed: isSaved
          ? () {
              Feedback.forTap(context);
              HapticFeedback.lightImpact();
              setState(() {
                removeFromSavedList(
                  savedItem: UmapSaved(
                      savedCategory: category,
                      savedID: document["id"][index],
                      savedName: document["name"][index],
                      savedDescription: document["description"][index],
                      savedImgUrl: document["imageUrl"][index]),
                  locationID: document["id"][index],
                );
                isSaved = false;
              });
            }
          : () {
              Feedback.forTap(context);
              HapticFeedback.lightImpact();
              setState(() {
                addToSavedList(
                  savedItem: UmapSaved(
                      savedCategory: category,
                      savedID: document["id"][index],
                      savedName: document["name"][index],
                      savedDescription: document["description"][index],
                      savedImgUrl: document["imageUrl"][index]),
                );
                isSaved = true;
              });
            },
      onPressed: () {
        Feedback.forTap(context);
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              category: category,
              documentID: document["id"][index],
              imgSrc: document["imageUrl"][index],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // ///Draggable Scrollable Sheet
    // return DraggableScrollableSheet(
    //   initialChildSize: .15,
    //   maxChildSize: .55,
    //   minChildSize: .15,
    //   builder: (context, scrollController) {
    //     return SingleChildScrollView(
    //       controller: scrollController,
    //       child: Container(
    //         decoration: BoxDecoration(
    //           // border: Border.all(color: Theme.of(context).primaryColor),
    //           color: Theme.of(context).scaffoldBackgroundColor,
    //           borderRadius: BorderRadius.vertical(
    //               top: Radius.circular(getRelativeScreenWidth(context, 32)),
    //               bottom: Radius.zero),
    //         ),
    //
    //         //color: Colors.white,
    //         width: screenWidth,
    //         height: screenHeight * .465,
    //         child: Stack(
    //           children: [
    //             Positioned(
    //               top: getRelativeScreenHeight(context, 40),
    //               left: getRelativeScreenHeight(context, 20),
    //               child: Padding(
    //                 padding: EdgeInsets.only(left: 8.0),
    //                 child: Text(
    //                   "Popular Places",
    //                   style: Theme.of(context).textTheme.headline1,
    //                   textAlign: TextAlign.left,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: getRelativeScreenHeight(context, 30),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.only(
    //                 top: getRelativeScreenHeight(context, 120),
    //                 //left: getRelativeScreenHeight(context, 20),
    //               ),
    //               child: StreamBuilder(
    //                 stream: umapFirestoreStream,
    //                 builder: (
    //                   BuildContext context,
    //                   AsyncSnapshot<QuerySnapshot> snapshot,
    //                 ) {
    //                   switch (snapshot.connectionState) {
    //                     case ConnectionState.waiting:
    //                       return Center(
    //                         child: CircularProgressIndicator.adaptive(),
    //                       );
    //                     default:
    //                       List<DocumentSnapshot> umapSourceDocuments =
    //                           snapshot.data!.docs;
    //                       return Container(
    //                         height: getRelativeScreenHeight(context, 240),
    //                         child: ListView.builder(
    //                           scrollDirection: Axis.horizontal,
    //                           //itemExtent: getRelativeScreenWidth(context, 240),
    //                           itemCount: umapSourceDocuments.length,
    //                           itemBuilder: (context, index) =>
    //                               buildPopularPlacesList(
    //                             context,
    //                             umapSourceDocuments[index],
    //                           ),
    //                         ),
    //                       );
    //                   }
    //                 },
    //               ),
    //             ),
    //
    //             ///Draggable icon indicator
    //             Padding(
    //               padding: const EdgeInsets.only(top: 10),
    //               child: Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Container(
    //                   height: getRelativeScreenHeight(context, 5),
    //                   width: getRelativeScreenWidth(context, 40),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.all(Radius.circular(5)),
    //                     color: Theme.of(context).accentColor,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
    return Container(
      width: screenWidth,
      height: screenHeight * .465,
      child: Stack(
        children: [
          Positioned(
            top: getRelativeScreenHeight(context, 40),
            left: getRelativeScreenHeight(context, 20),
            child: Text(
              "Popular Places",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: getRelativeScreenHeight(context, 25),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getRelativeScreenHeight(context, 120),
              //left: getRelativeScreenHeight(context, 20),
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).iconTheme.color!,
                        ),
                      ),
                    );
                  default:
                    List umapSourceDocumentsList = snapshot.data!.docs;
                    var umapSourceDocuments = umapSourceDocumentsList[0];
                    return Container(
                      height: getRelativeScreenHeight(context, 240),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        //itemExtent: getRelativeScreenWidth(context, 240),
                        itemCount: umapSourceDocuments["id"].length,
                        itemBuilder: (context, index) => buildPopularPlacesList(
                            context: context,
                            document: umapSourceDocuments,
                            index: index,
                            category: "administrative blocks"),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
