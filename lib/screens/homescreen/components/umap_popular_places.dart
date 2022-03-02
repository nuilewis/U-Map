import 'package:cloud_firestore/cloud_firestore.dart';
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
  late final LatLng markerLoc;
  List<bool> isSaved = [];
  String category = "administrative blocks";
  // String category = "classes";

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
    Map<String, dynamic> documentMap = document[category][index];

    for (int i = 0; i < umapSPList.length; i++) {
      ///Check if is saved
      if (umapSPList[i].savedID == documentMap["id"]) {
        isSaved[index] = true;
      }
    }

    ///Todo: Add code to find the most popular locations
    return PopularPlacesListItem(
      title: documentMap["name"],
      imageSrc: documentMap["imageUrl"],
      saveIconLink: isSaved[index]
          ? "assets/svg/heart_icon_filled.svg"
          : "assets/svg/heart_icon.svg",
      onSavedPressed: isSaved[index]
          ? () {
              Feedback.forTap(context);
              HapticFeedback.lightImpact();
              setState(() {
                removeFromSavedList(
                  savedItem: UmapSaved(
                      savedCategory: category,
                      savedID: documentMap["id"],
                      savedName: documentMap["name"],
                      savedDescription: documentMap["description"],
                      savedImgUrl: documentMap["imageUrl"]),
                  locationID: documentMap["id"],
                );
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
                      savedID: documentMap["id"],
                      savedName: documentMap["name"],
                      savedDescription: documentMap["description"],
                      savedImgUrl: documentMap["imageUrl"]),
                );
                isSaved[index] = true;
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
              documentID: documentMap["id"],
              imgSrc: documentMap["imageUrl"],
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
              stream: FirebaseFirestore.instance
                  .collection("umap_bamenda")
                  .doc("umap_uba_ref")
                  .collection(category)
                  .snapshots(),
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
                    DocumentSnapshot umapSourceDocuments =
                        snapshot.data!.docs[0];

                    ///Because there is only 1 document in the collection
                    if (umapSourceDocuments[category].isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "There isn't anything under this category",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: getRelativeScreenHeight(context, 240),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            //itemExtent: getRelativeScreenWidth(context, 240),
                            itemCount: umapSourceDocuments[category].length,
                            itemBuilder: (context, index) {
                              //Making all indexes of isSaved false
                              isSaved.add(false);

                              return buildPopularPlacesList(
                                  context: context,
                                  document: umapSourceDocuments,
                                  index: index,
                                  category: category);
                            }),
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
