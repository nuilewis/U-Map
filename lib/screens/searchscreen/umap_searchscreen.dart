import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/findscreen/components/umap_list_item.dart';
import 'package:u_map/screens/homescreen/components/umap_categories.dart';
import 'package:u_map/screens/homescreen/components/umap_app_bar.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/screens/searchscreen/services/searchservice.dart';

import '../../size_config.dart';

class UmapSearchScreen extends StatefulWidget {
  @override
  _UmapSearchScreenState createState() => _UmapSearchScreenState();
}

class _UmapSearchScreenState extends State<UmapSearchScreen> {
  //TextEditingController searchTerm = new TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];
  String selectedCategory = 'administrative blocks';
  int selectedIndex = 0;
  List<bool> onSelected = [true, false, false];

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

  bool isSaved = false;

  runSearch(searchTerm, searchCategory) {
    if (searchTerm.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    //Capitalizing the first character
    var capitaliseSearchTerm =
        searchTerm.substring(0, 1).toUpperCase() + searchTerm.substring(1);

    //Runs the query whe the first character is typed
    if (queryResultSet.length == 0 && searchTerm.length == 1) {
      SearchService()
          .searchByName(searchField: searchTerm, category: searchCategory)
          .then((QuerySnapshot snapshot) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          queryResultSet.add(snapshot.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        ///todo: replace search term with capitalised search term
        if (element["name"].startsWith(searchTerm)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

    return StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return buildSearchResult(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
              top: getRelativeScreenHeight(context, 110),
              left: getRelativeScreenWidth(context, 20),
              child: Text(
                "Categories",
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: getRelativeScreenHeight(context, 20),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: getRelativeScreenHeight(context, 170)),
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
                                  selectedCategory = umapCategories[index];
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
            Padding(
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
                      return buildSearchResult(
                          tempSearchStore.elementAt(index));
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
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
            )

            // GridView.count(
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 4,
            //   mainAxisSpacing: 4,
            //   primary: false,
            //   shrinkWrap: true,
            //   children: tempSearchStore.map((element) {
            //     return buildfakeCard(element);
            //   }).toList(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchResult(element) {
    print("search result too is ${element["name"]}");
    return UmapListItem(
      sourceLocation:
          LatLng(element["location"].latitude, element["location"].longitude),
      title: element["name"],
      description: element["description"],
      firstIconSvgLink: isSaved
          ? "assets/svg/heart_icon_filled.svg"
          : "assets/svg/heart_icon.svg",
      secondIconSvgLink: "assets/svg/forward_icon.svg",
      imgSrc: element["imgUrl"],
      firstIconOnPressed: isSaved
          ? () {
              Feedback.forTap(context);
              GeoPoint sourceLocation = element["location"];
              setState(() {
                removeFromSavedList(
                    savedItem: UmapSaved(
                      savedName: element["name"],
                      savedDescription: element["description"],
                      // savedDistance: calcDistance!.toStringAsFixed(2),
                      savedImgUrl: element["imageUrl"],
                      savedDistance: "1km",
                      savedLocationLatitude: sourceLocation.latitude.toDouble(),
                      savedLocationLongitude:
                          sourceLocation.latitude.toDouble(),
                    ),
                    locationName: element["name"]);
                isSaved = false;
              });
            }
          : () {
              Feedback.forTap(context);
              GeoPoint sourceLocation = element["location"];
              setState(() {
                addToSavedList(
                  savedItem: UmapSaved(
                    savedName: element["name"],
                    savedDescription: element["description"],
                    savedImgUrl: element["imageUrl"],

                    ///Todo: Replace Saved Distance with actual Saved distance
                    // savedDistance: calcDistance!.toStringAsFixed(2), savedDistance:
                    savedDistance: "1km",
                    savedLocationLatitude: sourceLocation.latitude.toDouble(),
                    savedLocationLongitude: sourceLocation.longitude.toDouble(),
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
                imgSrc: element["imageUrl"],
                name: element["name"],
                description: element["description"],
                markerLocation: LatLng(element["location"].latitude,
                    element["location"].longitude)),
          ),
        );
      },
    );
  }
}
