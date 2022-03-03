import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umapDrawer.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/homescreen/components/umap_categories.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/screens/searchscreen/services/searchservice.dart';

import '../../size_config.dart';

class UmapSearchScreen extends StatefulWidget {
  @override
  _UmapSearchScreenState createState() => _UmapSearchScreenState();
}

class _UmapSearchScreenState extends State<UmapSearchScreen> {
  TextEditingController searchforRef = new TextEditingController();
  List<DocumentSnapshot> queryResultSet = [];
  List<DocumentSnapshot> tempSearchStore = [];
  String selectedCategory = 'administrative blocks';
  int selectedIndex = 0;
  List<bool> onSelected = [true, false, false, false, false, false];
  late Widget resultToDisplay;

  List<String> categoryNames = [
    "Administrative Blocks",
    "Offices",
    "Classes",
    "Amphis",
    "Laboratories",
    "Leisures",
  ];

  String searchPrompt = "Search Something";
  List<Color> categoryColors = [
    Color(0xFFFAE788),
    Color(0xFF68E8D5),
    Color(0xFFFA9595),
    Color(0xFFFA9595),
    Color(0xFFFA9595),
    Color(0xFFFA9595),
  ];

  List<String> categoryIconLinks = [
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
    "assets/svg/home_icon.svg",
  ];

  List<String> umapCategories = [
    "administrative blocks",
    "offices",
    "classes",
    "amphi",
    "labs",
    "leisure",
  ];

  bool isSaved = false;

  runSearch(searchTerm, searchCategory) {
    if (searchTerm.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    //Capitalizing the first character
    String capitaliseSearchTerm =
        searchTerm.substring(0, 1).toUpperCase() + searchTerm.substring(1);

    //Runs the query when the first character is typed
    if (queryResultSet.length == 0 && searchTerm.length > 0) {
      SearchService()
          .searchByName(
              searchField: capitaliseSearchTerm, category: searchCategory)
          .then((QuerySnapshot snapshot) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          queryResultSet.add(snapshot.docs[i]);
        }
        tempSearchStore = [];
        queryResultSet.forEach((element) {
          if (element["name"].startsWith(capitaliseSearchTerm)) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        });
      });
    }
    //else {
    //   tempSearchStore = [];
    //   queryResultSet.forEach((element) {
    //     if (element["name"].startsWith(capitaliseSearchTerm)) {
    //       setState(() {
    //         tempSearchStore.add(element);
    //       });
    //     }
    //   });
    // }

    // return StreamBuilder(
    //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //   ///Todo: make screens to show when searching or no searching

    //   if (searchTerm.length == 0) {
    //     return Container(
    //       child: Center(
    //         child: Text(
    //           "Search Something",
    //           textAlign: TextAlign.center,
    //           style: Theme.of(context).textTheme.headline1,
    //         ),
    //       ),
    //     );
    //   } else {
    //     return buildSearchResult(snapshot,);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (searchforRef.text.isEmpty) {
      setState(() {
        resultToDisplay = Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .3,
                bottom: 20,
                left: 20,
                right: 20),
            child: Text(
              searchPrompt,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
        );
      });
    } else if (queryResultSet.isEmpty) {
      setState(() {
        resultToDisplay = Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .3, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Nothing Found",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  "Try refining your search term",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        );
      });
    } else {
      setState(() {
        resultToDisplay = Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding:
                EdgeInsets.only(top: getRelativeScreenHeight(context, 290)),
            child: ListView.builder(
                shrinkWrap: true,
                //itemExtent: getRelativeScreenHeight(context, 195),
                itemCount: tempSearchStore.length,
                itemBuilder: (context, index) {
                  // return tempSearchStore
                  //     .map((element) => buildSearchResult(element))
                  //     .toList() as Widget;

                  if (tempSearchStore.isNotEmpty) {
                    tempSearchStore.map((element) => null).toList();
                    return buildSearchResult(tempSearchStore.elementAt(index));
                  } else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              "Nothing Found",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "Try refining your search term",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
        );
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ///Search Bar Section
            Padding(
              padding:
                  EdgeInsets.only(top: getRelativeScreenHeight(context, 40)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    icon: SvgPicture.asset(
                      "assets/svg/back_icon.svg",
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  //SearchBar
                  Container(
                    width: getRelativeScreenWidth(context, 250),
                    height: getRelativeScreenHeight(context, 60),
                    padding: EdgeInsets.only(
                      top: getRelativeScreenWidth(context, 2),
                      left: getRelativeScreenWidth(context, 15),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      //color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(
                        getRelativeScreenWidth(context, 15),
                      ),
                      border: Border.all(
                          color: Theme.of(context)
                              .primaryColorLight
                              .withOpacity(.5)),
                    ),
                    child: TextField(
                      controller: searchforRef,
                      onChanged: (searchTerm) {
                        runSearch(searchTerm, selectedCategory);
                      },
                      //controller: searchTerm,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            icon: SvgPicture.asset(
                              "assets/svg/search_icon.svg",
                              color: Theme.of(context)
                                  .iconTheme
                                  .color!
                                  .withOpacity(.3),
                            ),
                            onPressed: () {},
                          ),
                          hintText: "Search",

                          //hintTextDirection: TextDirection.rtl,
                          border: InputBorder.none),
                      //textDirection: TextDirection.rtl,
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/svg/menu_icon.svg",
                      color: Theme.of(context).iconTheme.color,
                      //color: Colors.black,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                  SizedBox(
                    width: 0,
                  )
                ],
              ),
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 20),
            ),

            ///Categories Selector Section
            Positioned(
              top: getRelativeScreenHeight(context, 130),
              left: getRelativeScreenWidth(context, 20),
              child: Text(
                "Categories",
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 40),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: getRelativeScreenHeight(context, 190)),
              child: Container(
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
                        itemCount: umapCategories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Feedback.forTap(context);
                                HapticFeedback.lightImpact();
                                selectedIndex = index;
                                onSelected = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                                onSelected[index] = true;
                                setState(() {
                                  selectedCategory = umapCategories[index];
                                  searchPrompt =
                                      "Search ${categoryNames[index]}";
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
                    ],
                  ),
                ),
              ),
            ),

            ///Search Results Section
            // Padding(
            //   padding:
            //       EdgeInsets.only(top: getRelativeScreenHeight(context, 290)),
            //   child: ListView.builder(
            //       shrinkWrap: true,
            //       //itemExtent: getRelativeScreenHeight(context, 195),
            //       itemCount: tempSearchStore.length,
            //       itemBuilder: (context, index) {
            //         // return tempSearchStore
            //         //     .map((element) => buildSearchResult(element))
            //         //     .toList() as Widget;
            //
            //         if (tempSearchStore.isNotEmpty) {
            //           tempSearchStore.map((element) => null).toList();
            //           return buildSearchResult(
            //               tempSearchStore.elementAt(index));
            //         } else {
            //           return Center(
            //             child: Padding(
            //               padding: EdgeInsets.all(20),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   CircularProgressIndicator(),
            //                   Text(
            //                     "Nothing Found",
            //                     style: Theme.of(context).textTheme.bodyText1,
            //                   ),
            //                   Text(
            //                     "Try refining your search term",
            //                     style: Theme.of(context).textTheme.bodyText2,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         }
            //       }),
            // )
            resultToDisplay,
          ],
        ),
      ),
      endDrawer: UmapDrawer(),
    );
  }

  Widget buildSearchResult(DocumentSnapshot document) {
    print("search result too is ${document["name"]}");

    return UmapListItem(
      sourceLocation:
          LatLng(document["location"].latitude, document["location"].longitude),
      title: document["name"],
      description: document["description"],
      firstIconSvgLink: isSaved
          ? "assets/svg/heart_icon_filled.svg"
          : "assets/svg/heart_icon.svg",
      secondIconSvgLink: "assets/svg/forward_icon.svg",
      imgSrc: document["imageUrl"],
      firstIconOnPressed: isSaved
          ? () {
              Feedback.forTap(context);
              setState(() {
                removeFromSavedList(
                    savedItem: UmapSaved(
                      savedCategory: selectedCategory,
                      savedID: document.id,
                      savedName: document["name"],
                      savedDescription: document["description"],
                      // savedDistance: calcDistance!.toStringAsFixed(2),
                      savedImgUrl: document["imageUrl"],
                    ),
                    locationID: document.id);
                isSaved = false;
              });
            }
          : () {
              Feedback.forTap(context);
              setState(() {
                addToSavedList(
                  savedItem: UmapSaved(
                    savedCategory: selectedCategory,
                    savedID: document.id,
                    savedName: document["name"],
                    savedDescription: document["description"],
                    savedImgUrl: document["imageUrl"],
                  ),
                );
                isSaved = true;
              });
            },
      secondIconOnPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UmapLocationDetails(
              ///todo: find the correct id and put here
              documentID: document.id.toString(),
              category: selectedCategory,
              imgSrc: document["imageUrl"],
            ),
          ),
        );
      },
    );
  }
}
