import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import '../../../size_config.dart';

class UmapCategories extends StatefulWidget {
  @override
  _UmapCategoriesState createState() => _UmapCategoriesState();
}

class _UmapCategoriesState extends State<UmapCategories> {
  // late final Stream<QuerySnapshot> umapFirestoreStream =
  //     FirebaseFirestore.instance.collection('umap_uba').snapshots();
  late final Stream<QuerySnapshot> umapFirestoreStream;
  bool isSaved = false;
  late LatLng markerLoc;
  int selectedIndex = 0;
  List<bool> onSelected = [true, false, false];
  late String firestoreCategory = "administrative blocks";

  void initState() {
    super.initState();
    umapFirestoreStream = FirebaseFirestore.instance
        .collection("umap_bamenda")
        .doc("umap_uba")
        .collection(firestoreCategory)
        .snapshots();
  }

  List<String> categoryNames = [
    "Administrative\nBlocks",
    "Offices",
    "Class Rooms",
  ];

  List<Color> categoryColors = [
    Color(0xFFFAB8EE),
    Color(0xFF9C78EF),
    Color(0xFF69D2C4),
  ];

  List<String> categoryIconLinks = [
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
  ];

  List<String> umapCategories = [
    "administrative blocks",
    "offices",
    "classes",
  ];

  Widget buildPlacesList(
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
              GeoPoint sourceLocation = document["location"];
              setState(() {
                removeFromSavedList(
                    savedItem: UmapSaved(
                      savedName: document["name"],
                      savedDescription: document["description"],
                      savedImgUrl: document["imageUrl"],
                      // savedDistance: calcDistance!.toStringAsFixed(2),
                      savedDistance: "1km",
                      savedLocationLatitude: sourceLocation.latitude.toDouble(),
                      savedLocationLongitude:
                          sourceLocation.latitude.toDouble(),
                    ),
                    locationName: document["name"]);
                setState(() {
                  isSaved = false;
                });
              });
            }
          : () {
              Feedback.forTap(context);
              GeoPoint sourceLocation = document["location"];
              setState(() {
                addToSavedList(
                  savedItem: UmapSaved(
                    savedName: document["name"],
                    savedDescription: document["description"],
                    savedImgUrl: document["imageUrl"],

                    ///Todo: Replace Saved Distance with actual Saved distance
                    // savedDistance: calcDistance!.toStringAsFixed(2),
                    savedDistance: "1km",
                    savedLocationLatitude: sourceLocation.latitude.toDouble(),
                    savedLocationLongitude: sourceLocation.longitude.toDouble(),
                  ),
                );
                setState(() {
                  isSaved = false;
                });
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
              imgSrc: document["imageUrl"],
              name: document["name"],
              description: document["description"],
              markerLocation: markerLoc,
            ),
          ),
        );
      },
    );
  }

  // Widget buildCategories(BuildContext context, { required DocumentSnapshot document}){
  //   return CategoryItem(categoryName: document.id, categoryIconLink: '', color: color);
  // }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: getRelativeScreenWidth(context, 20)),
            child: Text(
              "Categories",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: getRelativeScreenHeight(context, 20),
          ),

          ///Categories Selector
          Container(
            height: getRelativeScreenHeight(context, 80),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: getRelativeScreenWidth(context, 10),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(), shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    //itemExtent: 100,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Feedback.forTap(context);
                            HapticFeedback.lightImpact();
                            selectedIndex = index;
                            onSelected = [false, false, false];
                            onSelected[index] = true;
                            setState(() {
                              firestoreCategory = umapCategories[index];
                            });
                          },
                          child: CategoryItem(
                            onSelected: onSelected[index],
                            categoryName: categoryNames[index],
                            color: categoryColors[index],
                            categoryIconLink: categoryIconLinks[index],
                          ));
                    },
                  ),
                  SizedBox(
                    width: getRelativeScreenWidth(context, 10),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: getRelativeScreenHeight(context, 30),
          ),

          ///Build List of Stores
          Container(
            child: StreamBuilder(
              stream: umapFirestoreStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).iconTheme.color!,
                        ),
                      ),
                    );
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
                    return Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemExtent: getRelativeScreenHeight(context, 195),
                          itemCount: umapSourceDocuments.length,
                          itemBuilder: (context, index) {
                            return buildPlacesList(
                              context,
                              document: umapSourceDocuments[index],
                            );
                          }),
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

class CategoryItem extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;
  final String categoryName;
  final String categoryIconLink;
  final bool onSelected;

  const CategoryItem(
      {Key? key,
      required this.categoryName,
      required this.categoryIconLink,
      required this.color,
      required this.onSelected,
      this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(
        horizontal: getRelativeScreenWidth(context, 10),
      ),
      decoration: BoxDecoration(
          color: onSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(width: 2, color: color)),
      height: getRelativeScreenHeight(context, 100),
      width: screenSize.width * .5,
      child: Stack(
        children: [
          // ///Icon
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: SvgPicture.asset(categoryIconLink,
          //       color: onSelected ? Colors.black : color),
          // ),
          Positioned(
            bottom: 10,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getRelativeScreenWidth(context, 10)),
              child: Text(categoryName,
                  style: onSelected
                      ? Theme.of(context).textTheme.headline2
                      : Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: color)),
            ),
          ),
        ],
      ),
    );
  }
}
