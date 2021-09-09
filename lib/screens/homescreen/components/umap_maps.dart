import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/screens/homescreen/components/firebase_error_screen.dart';
import 'package:u_map/screens/homescreen/components/umap_icon_button.dart';
import 'package:u_map/size_config.dart';

class UmapMaps extends StatefulWidget {
  @override
  _UmapMapsState createState() => _UmapMapsState();
}

class _UmapMapsState extends State<UmapMaps> {
  static final LatLng _center = const LatLng(6.012484, 10.259225);
  MapType _currentMapType = MapType.normal;
  GoogleMapController? mapController;
  final Stream<QuerySnapshot> umapStream =
      FirebaseFirestore.instance.collection('umap_uba').snapshots();

  ///Changing Map Type
  _setCurrentMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        loadUMapMap(),
        //Change Map Type Button
        Positioned(
          right: getRelativeScreenWidth(context, 20),
          bottom: screenHeight *
              .25, // bcs draggable scroll sheet has a min height of .2 of screen height, so it is always above
          // child: Container(
          //   width: getRelativeScreenWidth(context, 60),
          //   height: getRelativeScreenWidth(context, 60),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).scaffoldBackgroundColor,
          //     borderRadius: BorderRadius.circular(
          //       getRelativeScreenWidth(context, 20),
          //     ),
          //   ),
          //   child: IconButton(
          //     icon: SvgPicture.asset(
          //       "assets/svg/map_change_icon.svg",
          //       color: Theme.of(context).iconTheme.color,
          //     ),
          //     onPressed: _setCurrentMapType(),
          //   ),
          // ),

          child: UmapIconButton(
            iconLink: "assets/svg/map_change_icon.svg",
            onPressed: _setCurrentMapType(),
            bgColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: Theme.of(context).iconTheme.color,
          ),
        )
      ],
    );
  }

  ///Load UMap Maps

  Widget loadUMapMap() {
    return StreamBuilder(
      stream: umapStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          ///TODO: build a page to return the error
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UmapFireStoreError(
                    firebaseErrorDetails: "${snapshot.error}",
                    firebaseErrorMsg: "Ooops!"),
              ),
            );
          });

          //return null;
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).iconTheme.color ??
                      Theme.of(context).accentColor,
                ),
              ),
            );
          case ConnectionState.none:
            return Center(
              child: Text(
                'Oops, you seem to be offline!',
                style: Theme.of(context).textTheme.headline2,
              ),
            );
          default:

          ///TODO: Write what to do when theres internet
        }
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17,
          ),
          mapType: _currentMapType,
          myLocationEnabled: true,
        );
      },
    );
  }
}
