import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late final Stream<QuerySnapshot> umapFirestoreStream;
  late LatLng markerLoc;
  int selectedIndex = 0;
  List<bool> onSelected = [true, false, false];
  String firestoreCategory = "administrative blocks";
  late Widget streamToShow;
  late List<Widget> streams = [];
  List<String> categoryNames = [
    "Classes",
    "Administrative\nBlocks",
    "Offices",
  ];
  List<Color> categoryColors = [
    Color(0xFFFAE788),
    Color(0xFF68E8D5),
    Color(0xFFFA9595),
  ];
  //Color categoryColors = Color(0xFF85C9F6);
  //Color categoryColors = cSecondaryColor;
  List<String> categoryIconLinks = [
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
  ];
  List<String> umapCategories = [
    "classes",
    "administrative blocks",
    "offices",
  ];
  List<bool> isSaved = [];

  @override
  initState() {
    super.initState();
    initUmapSharedPreferences();
    // streamToShow = classesStream();
    // streams = [
    //   classesStream(),
    //   adminStream(),
    //   officesStream(),
    // ];
    umapFirestoreStream = FirebaseFirestore.instance
        .collection("umap_bamenda")
        .doc("umap_uba_ref")
        .collection(firestoreCategory)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                            //streamToShow = streams[index];
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
        StreamToShow(firestoreCategory: firestoreCategory)
      ],
    );
  }
}

class StreamToShow extends StatefulWidget {
  final String firestoreCategory;
  const StreamToShow({Key? key, required this.firestoreCategory})
      : super(key: key);

  @override
  _StreamToShowState createState() => _StreamToShowState();
}

class _StreamToShowState extends State<StreamToShow> {
  List<bool> isSaved = [];
  Widget buildPlacesList({
    required BuildContext context,
    required DocumentSnapshot document,
    required int index,
    required String category,
  }) {
    for (int i = 0; i < umapSPList.length; i++) {
      ///Check if is saved
      if (umapSPList[i].savedID == document["id"][index]) {
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
                      savedCategory: widget.firestoreCategory,
                      savedID: document["id"][index],
                      savedName: document["name"][index],
                      savedDescription: document["description"][index],
                      savedImgUrl: document["imageUrl"][index],
                    ),
                    locationID: document["id"][index]);

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
                    savedID: document["id"][index],
                    savedName: document["name"][index],
                    savedDescription: document["description"][index],
                    savedImgUrl: document["imageUrl"][index],
                  ),
                );

                isSaved[index] = true;
              });
            },
      secondIconSvgLink: "assets/svg/forward_icon.svg",
      secondIconOnPressed: () {
        Feedback.forTap(context);
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              category: widget.firestoreCategory,
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("umap_bamenda")
            .doc("umap_uba_ref")
            .collection(widget.firestoreCategory)
            .snapshots(),
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
              DocumentSnapshot umapSourceDocuments = snapshot.data!.docs[0];

              ///0 bcs there is only 1 document in the collection
              if (umapSourceDocuments["id"].isNotEmpty) {
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemExtent: getRelativeScreenHeight(context, 195),
                    itemCount: umapSourceDocuments["id"].length,
                    itemBuilder: (context, index) {
                      //Making all indexes of isSaved false
                      isSaved.add(false);

                      return buildPlacesList(
                        context: context,
                        document: umapSourceDocuments,
                        index: index,
                        category: widget.firestoreCategory,
                      );
                    });
              } else {
                return Center(
                  child: Text(
                    "We can't find anything under this category",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }
          }
        });
  }
}

/// Category Item Widget
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
        color: onSelected ? color : Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
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
                  horizontal: getRelativeScreenWidth(context, 15)),
              child: Text(categoryName,
                  style: onSelected
                      ? Theme.of(context).textTheme.headline2?.copyWith(
                            color: Color(0xFF101011),
                          )
                      : Theme.of(context).textTheme.headline2),
            ),
          ),
        ],
      ),
    );
  }
}
