import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/constants.dart';
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
  List<bool> isSaved = [];
  List<bool> onSelected = [true, false, false];
  String firestoreCategory = "administrative blocks";
  late Widget streamToShow;
  late List<Widget> streams = [];

  void initState() {
    super.initState();
    streamToShow = classesStream();
    streams = [
      classesStream(),
      adminStream(),
      officesStream(),
    ];
    umapFirestoreStream = FirebaseFirestore.instance
        .collection("umap_bamenda")
        .doc("umap_uba_ref")
        .collection(firestoreCategory)
        .snapshots();
  }

  List<String> categoryNames = [
    "Classes",
    "Administrative\nBlocks",
    "Offices",
  ];

  // List<Color> categoryColors = [
  //   Color(0xFFFAB8EE),
  //   Color(0xFF9C78EF),
  //   Color(0xFF69D2C4),
  // ];
  //Color categoryColors = Color(0xFF85C9F6);
  Color categoryColors = cSecondaryColor;

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

  Widget buildPlacesList(
    BuildContext context, {
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

              setState(() {
                removeFromSavedList(
                    savedItem: UmapSaved(
                      savedCategory: firestoreCategory,
                      savedID: document["id"][index],
                      savedName: document["name"][index],
                      savedDescription: document["description"][index],
                      savedImgUrl: document["imageUrl"][index],
                    ),
                    locationID: document[index].id);

                isSaved[index] = !isSaved[index];
              });
            }
          : () {
              Feedback.forTap(context);
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

                isSaved[index] = !isSaved[index];
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
              category: firestoreCategory,
              documentID: document["id"][index],
              imgSrc: document["imageUrl"][index],
            ),
          ),
        );
      },
    );
  }

  // Widget streamToShow(
  //     {required Stream<QuerySnapshot> firestoreStream,
  //     required String firestoreCategory}) {
  //   return StreamBuilder(
  //     stream: firestoreStream,
  //     builder: (
  //       BuildContext context,
  //       AsyncSnapshot<QuerySnapshot> snapshot,
  //     ) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.none:
  //           return Center(
  //             child: CircularProgressIndicator.adaptive(
  //               backgroundColor: Colors.transparent,
  //               valueColor: AlwaysStoppedAnimation<Color>(
  //                 Theme.of(context).iconTheme.color!,
  //               ),
  //             ),
  //           );
  //         case ConnectionState.waiting:
  //           return Center(
  //             child: CircularProgressIndicator.adaptive(
  //               backgroundColor: Colors.transparent,
  //               valueColor: AlwaysStoppedAnimation<Color>(
  //                 Theme.of(context).iconTheme.color!,
  //               ),
  //             ),
  //           );
  //         default:
  //           DocumentSnapshot umapSourceDocuments = snapshot.data!.docs[0];
  //
  //           ///0 bcs there is only 1 document in the collection
  //
  //           return Container(
  //             child: ListView.builder(
  //                 physics: NeverScrollableScrollPhysics(),
  //                 scrollDirection: Axis.vertical,
  //                 shrinkWrap: true,
  //                 itemExtent: getRelativeScreenHeight(context, 195),
  //                 itemCount: umapSourceDocuments["id"].length,
  //                 itemBuilder: (context, index) {
  //                   //Making all indexes of isSaved false
  //
  //                   isSaved.add(false);
  //
  //                   return buildPlacesList(
  //                     context,
  //                     document: umapSourceDocuments,
  //                     index: index,
  //                     category: firestoreCategory,
  //                   );
  //                 }),
  //           );
  //       }
  //     },
  //   );
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
                              streamToShow = streams[index];
                            });
                          },
                          child: CategoryItem(
                            onSelected: onSelected[index],
                            categoryName: categoryNames[index],
                            color: categoryColors,
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
          Container(child: streamToShow),
        ],
      ),
    );
  }

  ///The three different stream builders for the different categories;

  Widget adminStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("umap_bamenda")
          .doc("umap_uba_ref")
          .collection("administrative blocks")
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasData) {
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

              return Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemExtent: getRelativeScreenHeight(context, 195),
                    itemCount: umapSourceDocuments["id"].length,
                    itemBuilder: (context, index) {
                      //Making all indexes of isSaved false

                      isSaved.add(false);

                      return buildPlacesList(
                        context,
                        document: umapSourceDocuments,
                        index: index,
                        category: "administrative blocks",
                      );
                    }),
              );
          }
        } else {
          return Center(
            child: Text(
              "Hmm, we can't find anything under this category",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
      },
    );
  }

  Widget classesStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("umap_bamenda")
          .doc("umap_uba_ref")
          .collection("classes")
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasData) {
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

              return Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemExtent: getRelativeScreenHeight(context, 195),
                    itemCount: umapSourceDocuments["id"].length,
                    itemBuilder: (context, index) {
                      //Making all indexes of isSaved false

                      isSaved.add(false);

                      return buildPlacesList(
                        context,
                        document: umapSourceDocuments,
                        index: index,
                        category: "classes",
                      );
                    }),
              );
          }
        } else {
          return Center(
            child: Text(
              "Hmm, we can't find anything under this category",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
      },
    );
  }

  Widget officesStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("umap_bamenda")
          .doc("umap_uba_ref")
          .collection("offices")
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasData) {
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

              return Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemExtent: getRelativeScreenHeight(context, 195),
                    itemCount: umapSourceDocuments["id"].length,
                    itemBuilder: (context, index) {
                      //Making all indexes of isSaved false

                      isSaved.add(false);

                      return buildPlacesList(
                        context,
                        document: umapSourceDocuments,
                        index: index,
                        category: "offices",
                      );
                    }),
              );
          }
        } else {
          return Center(
            child: Text(
              "Hmm, we can't find anything under this category",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
      },
    );
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
          color: onSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(
              width: 2,
              color: onSelected ? color : Theme.of(context).iconTheme.color!)),
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
                  style: Theme.of(context).textTheme.headline2),
            ),
          ),
        ],
      ),
    );
  }
}
