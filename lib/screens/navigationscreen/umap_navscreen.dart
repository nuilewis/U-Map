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
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Theme.of(context).primaryColor),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                            getRelativeScreenWidth(context, 32)),
                        bottom: Radius.zero),
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
