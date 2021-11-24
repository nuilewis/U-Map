import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:u_map/components/umapDrawer.dart';
import 'package:u_map/components/umap_directions/directions_model.dart';
import 'package:u_map/components/umap_directions/get_directions_method.dart';
import 'package:u_map/components/umap_distance_calculator/umap_dist_calculator.dart';
import 'package:u_map/components/umap_location/umap_location.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/homescreen/components/umap_icon_button.dart';
import 'package:u_map/screens/navigationscreen/umap_navscreen.dart';
import 'package:u_map/size_config.dart';
import 'components/location_details_description.dart';
import 'components/umap_text_button.dart';

class UmapLocationDetails extends StatefulWidget {
  final String imgSrc;
  final String documentID;
  final String category;

  const UmapLocationDetails({
    Key? key,
    required this.imgSrc,
    required this.documentID,
    required this.category,
  }) : super(key: key);
  @override
  _UmapLocationDetailsState createState() => _UmapLocationDetailsState();
}

class _UmapLocationDetailsState extends State<UmapLocationDetails> {
  ///Todo: Make current location get actual current location
  LatLng? currentLocation = LatLng(6.002342, 10.264345);
  late final Directions? directionInfo;
  double? calcDistance;
  late String name;
  late String description;
  late final Stream<QuerySnapshot> fireStoreStream;
  LatLng? markerLocation;
  bool isSaved = false;
  bool isDoingWork = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUmapSharedPreferences();
    checkIsSaved();

    fireStoreStream = FirebaseFirestore.instance
        .collection("umap_bamenda")
        .doc("umap_uba")
        .collection(widget.category)
        .where(FieldPath.documentId, isEqualTo: widget.documentID)
        .snapshots();
  }

  getCurrentLocation() async {
    LocationData? location = await getLocation();
    double? locLat = location!.latitude;
    double? locLong = location.longitude;

    if (locLat != null && locLong != null) {
      currentLocation = LatLng(locLat, locLong);
    }
    return currentLocation;
  }

  void checkIsSaved() {
    for (int i = 0; i < umapSPList.length; i++) {
      if (umapSPList[i].savedID == widget.documentID) {
        isSaved = true;
      }
    }
  }

  calculateDistance(LatLng currentLoc, LatLng markerLoc) async {
    return calcDistance = distanceCalculator(currentLoc, markerLoc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: getRelativeScreenHeight(context, 90),
        elevation: 0,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svg/back_icon.svg",
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: getRelativeScreenWidth(context, 15),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/svg/menu_icon.svg",
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: UmapDrawer(),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: fireStoreStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot document = snapshot.data!.docs[0];

                ///Because it is returning only 1 document which matches the requested ID

                // currentLocation = getCurrentLocation();

                markerLocation = LatLng(document["location"].latitude,
                    document["location"].longitude);

                name = document["name"];
                description = document["description"];

                if (currentLocation != null) {
                  calcDistance =
                      calculateDistance(currentLocation!, markerLocation!);
                }
              }
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getRelativeScreenHeight(context, 120)),

                      ///Picture container
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: getRelativeScreenWidth(context, 20),
                        ),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * .65,
                        decoration: BoxDecoration(
                          ///Todo: make it show a loading icon when loading the image

                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(
                            getRelativeScreenWidth(context, 32),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            getRelativeScreenWidth(context, 32),
                          ),
                          child: CachedNetworkImage(
                            fadeOutDuration: const Duration(milliseconds: 250),
                            fadeInDuration: const Duration(milliseconds: 250),
                            fadeInCurve: Curves.easeOut,
                            fadeOutCurve: Curves.easeOut,
                            fit: BoxFit.cover,
                            imageUrl: widget.imgSrc,
                            placeholder: (context, imgSrc) =>
                                CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).iconTheme.color!),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getRelativeScreenHeight(context, 20),
                      ),

                      ///Buttons Section Below
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getRelativeScreenWidth(context, 20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: getRelativeScreenWidth(context, 5),
                            ),

                            ///Distance Text
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      // text: calcDistance
                                      //     "calculating",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                  TextSpan(
                                      text: " km",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2),
                                ],
                              ),
                            ),

                            ///Add to  and remove from saved Button
                            isSaved
                                ? UmapIconButton(
                                    iconLink:
                                        "assets/svg/heart_icon_filled.svg",
                                    iconColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        removeFromSavedList(
                                            savedItem: UmapSaved(
                                              savedCategory: widget.category,
                                              savedID: widget.documentID,
                                              savedName: name,
                                              savedDescription: description,
                                              savedImgUrl: widget.imgSrc,
                                            ),
                                            locationID: widget.documentID);

                                        isSaved = !isSaved;
                                      });
                                    },
                                    bgColor: Theme.of(context).primaryColor,
                                  )
                                : UmapIconButton(
                                    iconLink: "assets/svg/heart_icon.svg",
                                    onPressed: () {
                                      setState(() {
                                        addToSavedList(
                                          savedItem: UmapSaved(
                                            savedCategory: widget.category,
                                            savedID: widget.documentID,
                                            savedName: name,
                                            savedDescription: description,
                                            savedImgUrl: widget.imgSrc,
                                          ),
                                        );
                                        isSaved = !isSaved;
                                      });
                                    },
                                    bgColor: Colors.transparent,
                                  ),

                            UmapTextButton(
                                isDoingWork: isDoingWork,
                                buttonText: "Get Directions",
                                buttonIconLink: "assets/svg/direction_icon.svg",
                                onPressed: () async {
                                  Feedback.forTap(context);
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isDoingWork = true;
                                  });

                                  directionInfo = await getDirections(
                                      currentLocation!, markerLocation!);
                                  Future.delayed(Duration(seconds: 1),
                                      () async {
                                    setState(() {
                                      isDoingWork = false;
                                    });
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return UMapNavigationScreen(
                                            name: name,
                                            description: description,
                                            directionInfo: directionInfo);
                                      },
                                    ));
                                  });
                                })
                          ],
                        ),
                      ),

                      SizedBox(
                        height: getRelativeScreenHeight(context, 20),
                      ),

                      ///Description Section
                      LocDetailsDescriptionSection(
                        name: name,
                        description: description,
                      ),
                    ],
                  );
              }
            }),
      ),
    );
  }
}
