import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:u_map/components/umapDrawer.dart';
import 'package:u_map/components/umap_directions/directions_model.dart';
import 'package:u_map/components/umap_directions/get_directions_method.dart';
import 'package:u_map/components/umap_location/umap_location.dart';
import 'package:u_map/components/umap_shared_preferences/umap_shared_preferences.dart';
import 'package:u_map/components/umap_shared_preferences/umap_sp_methods.dart';
import 'package:u_map/screens/homescreen/components/umap_icon_button.dart';
import 'package:u_map/screens/navigationscreen/umap_navscreen.dart';
import 'package:u_map/size_config.dart';

import 'components/location_details_description.dart';
import 'components/umap_text_button.dart';

class UmapLocationDetails extends StatefulWidget {
  final String name;
  final String description;
  final String imgSrc;
  final LatLng markerLocation;

  const UmapLocationDetails(
      {Key? key,
      required this.name,
      required this.description,
      required this.imgSrc,
      required this.markerLocation})
      : super(key: key);
  @override
  _UmapLocationDetailsState createState() => _UmapLocationDetailsState();
}

class _UmapLocationDetailsState extends State<UmapLocationDetails> {
  ///Todo: Make current location get actual current location
  //LatLng? currentLocation; = LatLng(6.002342, 10.264345);
  LatLng? currentLocation;
  late final Directions? directionInfo;
  double? calcDistance;
  bool isSaved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUmapSharedPreferences();
    checkIsSaved();
  }

  getCurrentLocation() async {
    LocationData? location = await getLocation();

    ///currentLocation = LatLng(location!.latitude, location!.longitude);
    return currentLocation;
  }

  void checkIsSaved() {
    for (int i = 0; i < umapSPList.length; i++) {
      if (umapSPList[i].savedName == widget.name) {
        isSaved = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getRelativeScreenHeight(context, 120)),
            // ///Top bar and menu
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: getRelativeScreenWidth(context, 20),
            //     vertical: getRelativeScreenHeight(context, 30),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       IconButton(
            //         icon: SvgPicture.asset(
            //           "assets/svg/back_icon.svg",
            //           color: Theme.of(context).iconTheme.color,
            //         ),
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //       ),
            //       IconButton(
            //         icon: SvgPicture.asset(
            //           "assets/svg/menu_icon.svg",
            //           color: Theme.of(context).iconTheme.color,
            //         ),
            //         onPressed: () {},
            //       ),
            //     ],
            //   ),
            // ),

            ///Picture container
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: getRelativeScreenWidth(context, 20),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .65,
              decoration: BoxDecoration(
                ///Todo: make it show a loading icon when loading the image
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.imgSrc,
                    )),
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  getRelativeScreenWidth(context, 32),
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
                            text: "1.3",
                            style: Theme.of(context).textTheme.headline1),
                        TextSpan(
                            text: " km",
                            style: Theme.of(context).textTheme.headline2),
                      ],
                    ),
                  ),

                  ///Add to  and remove from saved Button
                  isSaved
                      ? UmapIconButton(
                          iconLink: "assets/svg/heart_icon_filled.svg",
                          iconColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              removeFromSavedList(
                                  savedItem: UmapSaved(
                                    savedName: widget.name,
                                    savedDescription: widget.description,
                                    savedImgUrl: widget.imgSrc,
                                    // savedDistance:
                                    //     calcdistance!.toStringAsFixed(2),
                                    savedDistance: "1.23km",
                                    savedLocationLatitude: widget
                                        .markerLocation.latitude
                                        .toDouble(),
                                    savedLocationLongitude: widget
                                        .markerLocation.longitude
                                        .toDouble(),
                                  ),
                                  locationName: widget.name);

                              isSaved = false;
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
                                  savedName: widget.name,
                                  savedDescription: widget.description,
                                  savedImgUrl: widget.imgSrc,
                                  //savedDistance: calcdistance!.toStringAsFixed(2),
                                  savedDistance: "1.23km",
                                  savedLocationLatitude:
                                      widget.markerLocation.latitude.toDouble(),
                                  savedLocationLongitude: widget
                                      .markerLocation.longitude
                                      .toDouble(),
                                ),
                              );
                              isSaved = true;
                            });
                          },
                          bgColor: Colors.transparent,
                        ),

                  UmapTextButton(
                      buttonText: "Get Directions",
                      buttonIconLink: "assets/svg/direction_icon.svg",
                      onPressed: () async {
                        Feedback.forTap(context);
                        HapticFeedback.lightImpact();
                        directionInfo = await getDirections(
                            currentLocation!, widget.markerLocation);
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UMapNavigationScreen(
                                    name: widget.name,
                                    description: widget.description,
                                    directionInfo: directionInfo),
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
              name: widget.name,
              description: widget.description,
            ),
          ],
        ),
      ),
    );
  }
}
