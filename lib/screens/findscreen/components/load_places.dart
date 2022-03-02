import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';

import '../../../size_config.dart';

class LoadPlaces extends StatefulWidget {
  //final Stream<QuerySnapshot> stream;
  final String category;
  //final String refDatabaseID;

  const LoadPlaces({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _LoadPlacesState createState() => _LoadPlacesState();
}

class _LoadPlacesState extends State<LoadPlaces> {
  late LatLng markerLoc;
  String? savedIconLink;
  late VoidCallback onSavedPressed;
  List<bool> isSaved = [];
  double? calcDistance;

  Widget buildPlacesList(
    BuildContext context, {
    required DocumentSnapshot document,
    required String category,
    required int index,
  }) {
    Map<String, dynamic> documentMap = document[widget.category][index];

    for (int i = 0; i < umapSPList.length; i++) {
      ///Check if is saved
      if (umapSPList[i].savedID == documentMap["id"]) {
        isSaved[index] = true;
      }
    }
    return UmapListItem(
      title: documentMap["name"],
      description: documentMap["description"],
      imgSrc: documentMap["imageUrl"],
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
                      savedName: documentMap["name"],
                      savedID: documentMap["id"],
                      savedDescription: documentMap["description"],
                      savedImgUrl: documentMap["imageUrl"],
                    ),
                    locationID: documentMap["id"]);
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
                    savedName: documentMap["name"],
                    savedID: documentMap["id"],
                    savedDescription: documentMap["description"],
                    savedImgUrl: documentMap["imageUrl"],
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
              imgSrc: documentMap["imageUrl"],
              documentID: documentMap["id"],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("umap_bamenda")
          .doc("umap_uba_ref")
          .collection(widget.category)
          .snapshots(),
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
            DocumentSnapshot umapSourceDocuments = snapshot.data!.docs[0];

            ///Because there is only 1 document in the collection
            if (umapSourceDocuments[widget.category].isEmpty) {
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
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemExtent: getRelativeScreenHeight(context, 195),
                itemCount: umapSourceDocuments[widget.category].length,
                itemBuilder: (context, index) {
                  isSaved.add(false);

                  return buildPlacesList(context,
                      index: index,
                      document: umapSourceDocuments,
                      category: widget.category);
                },
              );
            }
        }
      },
    );
  }
}
