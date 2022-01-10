import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umapDrawer.dart';
import 'package:u_map/components/umap_directions/directions_model.dart';
import 'package:u_map/screens/homescreen/components/umap_maps.dart';
import 'package:u_map/screens/homescreen/components/umap_app_bar.dart';
import 'package:u_map/size_config.dart';

class UMapNavigationScreen extends StatefulWidget {
  final Directions? directionInfo;
  final String name;
  final String description;
  final String imgSrc;
  final LatLng locationCoordinates;
  final String locationID;

  const UMapNavigationScreen({
    Key? key,
    required this.name,
    required this.description,
    required this.directionInfo,
    required this.imgSrc,
    required this.locationCoordinates,
    required this.locationID,
  }) : super(key: key);
  @override
  _UMapNavigationScreenState createState() => _UMapNavigationScreenState();
}

class _UMapNavigationScreenState extends State<UMapNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: UmapAppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("assets/svg/back_icon.svg", color: Theme.of(context).iconTheme.color,)),
      ),
      endDrawer: UmapDrawer(),
      body: Stack(
        children: [
          // ///Navigation Info Area
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Text('Navigating to'),
          //     Text(widget.name),
          //     Text(widget.description),
          //   ],
          // ),

          ///Maps Container
          UmapMaps(
            directionInformation: widget.directionInfo,
            name: widget.name,
            locationCoordinates: widget.locationCoordinates,
            locationID: widget.locationID,
          ),
          DraggableScrollableSheet(
            initialChildSize: .3,
            maxChildSize: .3,
            minChildSize: .1,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                //physics: NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: Container(
                  height: screenSize.height * .3,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Theme.of(context).primaryColor),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                            getRelativeScreenWidth(context, 32)),
                        bottom: Radius.zero),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 20,
                        child: Text(
                          "Navigating To...",
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    color: Theme.of(context)
                                        .iconTheme
                                        .color!
                                        .withOpacity(.2),
                                  ),
                        ),
                      ),

                      ///Area with image and description text
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: getRelativeScreenWidth(context, 20),
                                    top: getRelativeScreenHeight(context, 40)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name,
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    SizedBox(
                                      height:
                                          getRelativeScreenHeight(context, 10),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            widget.directionInfo!.totalDistance,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                        SizedBox(
                                          width: getRelativeScreenWidth(
                                              context, 20),
                                        ),

                                        ///Divider container
                                        Container(
                                          color: Theme.of(context).primaryColor,
                                          height: 40,
                                          width: 2,
                                        ),
                                        SizedBox(
                                          width: getRelativeScreenWidth(
                                              context, 20),
                                        ),
                                        Text(
                                            widget.directionInfo!.totalDuration,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                right: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              height: screenSize.height * .3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        widget.imgSrc,
                                      )),
                                  borderRadius: BorderRadius.circular(25),
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
