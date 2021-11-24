import 'package:flutter/material.dart';
import 'package:u_map/components/umapDrawer.dart';
import 'package:u_map/components/umap_directions/directions_model.dart';
import 'package:u_map/screens/homescreen/components/umap_maps.dart';
import 'package:u_map/screens/homescreen/components/umap_app_bar.dart';
import 'package:u_map/size_config.dart';

class UMapNavigationScreen extends StatefulWidget {
  final Directions? directionInfo;
  final String name;
  final String description;
  final String? imgSrc;

  const UMapNavigationScreen({
    Key? key,
    required this.name,
    required this.description,
    required this.directionInfo,
    this.imgSrc,
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
      appBar: UmapAppBar(),
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
          ),
          DraggableScrollableSheet(
            initialChildSize: .2,
            maxChildSize: .4,
            minChildSize: .05,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: Container(
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
                          "Navigating To..",
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1!
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
                              child: Column(
                                children: [
                                  Text(
                                    widget.name,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  Row(
                                    children: [
                                      Text(widget.directionInfo!.totalDistance,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                      Text('Km'),

                                      ///Image container
                                      Container(
                                        color: Theme.of(context).primaryColor,
                                        height: 30,
                                        width: 2,
                                      ),
                                      Text(
                                        widget.directionInfo!.totalDuration,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                height: getRelativeScreenHeight(context, 195),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ))
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
