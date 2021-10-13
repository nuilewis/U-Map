import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:u_map/components/umap_directions/directions_model.dart';
import 'package:u_map/components/umap_location/umap_location.dart';
import 'package:u_map/components/umap_location/umap_permissions.dart';
import 'file:///C:/Users/Lewis/AndroidStudioProjects/u-map/lib/screens/errorscreen/firebase_error_screen.dart';
import 'package:u_map/screens/homescreen/components/umap_icon_button.dart';
import 'package:u_map/screens/locationDetailsScreen/umap_location_details.dart';
import 'package:u_map/size_config.dart';
import 'dart:async';
import 'package:location/location.dart';

class UmapMaps extends StatefulWidget {
  final Directions? directionInformation;

  const UmapMaps({Key? key, required this.directionInformation})
      : super(key: key);

  @override
  _UmapMapsState createState() => _UmapMapsState();
}

class _UmapMapsState extends State<UmapMaps> {
  static final LatLng _center = const LatLng(6.012484, 10.259225);
  final Stream<QuerySnapshot> umapStream =
      FirebaseFirestore.instance.collection('umap_uba').snapshots();
  MapType _currentMapType = MapType.normal;
  GoogleMapController? mapController;
  BitmapDescriptor? mapMarker;
  final Set<Marker> uMapMarkers = {};
  LatLng? currentLocation;
  LatLng? markerLocation;
  LatLng _lastMapPosition = _center;
  Directions? directionInfo;
  Directions? directionFromGoogle;

  Set<Marker> setMarkers() {
    return uMapMarkers;
  }

  @override
  initState() {
    //Initialising direction Info
    directionInfo = widget.directionInformation;
    super.initState();
  }

  ///Setting a custom marker
  setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assetS/images/marker_icon.png");
  }

  ///Changing Map Type
  _setCurrentMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  ///getting the current location
  getCurrentLocation() async {
    PermissionStatus? currentPermissionStatus = await getPermissionStatus();
    if (currentPermissionStatus == PermissionStatus.granted) {
      final LocationData currentLocData = await getLocation();
      currentLocation =
          LatLng(currentLocData.latitude!, currentLocData.longitude!);
    }
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

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
          child: UmapIconButton(
            iconLink: "assets/svg/map_change_icon.svg",
            onPressed: () {
              _setCurrentMapType();
            },
            bgColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }

  ///Load UMap Maps

  Widget loadUMapMap() {
    return StreamBuilder(
      stream: umapStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UmapErrorScreen(
                  errorDetails: "${snapshot.error}",
                  errorMessage: "Ooops!",
                  showBackButton: true,
                ),
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
                      Theme.of(context).colorScheme.secondary,
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
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              markerLocation = LatLng(
                snapshot.data!.docs[i]["location"].latitude,
                snapshot.data!.docs[i]["location"].longitude,
              );

              uMapMarkers.add(
                new Marker(
                  flat: false,
                  draggable: false,
                  zIndex: 5,
                  icon: BitmapDescriptor.defaultMarker,

                  ///Todo: Add custom marker icon here
                  markerId: MarkerId(snapshot.data!.docs[i]["name"]),
                  position: markerLocation!,
                  infoWindow: InfoWindow(title: snapshot.data!.docs[i]["name"]),
                  onTap: () async {
                    directionFromGoogle = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UmapLocationDetails(
                          imgSrc: snapshot.data!.docs[i]["imageUrl"],
                          name: snapshot.data!.docs[i]["name"],
                          description: snapshot.data!.docs[i]["description"],
                          markerLocation: markerLocation!,
                        ),
                      ),
                    );

                    setState(() {
                      directionInfo = directionFromGoogle;
                    });
                  },
                ),
              );
            }
        }
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17,
          ),
          mapType: _currentMapType,
          markers: setMarkers(),
          onCameraMove: _onCameraMove,
          myLocationEnabled: true,
          polylines: {
            if (directionInfo != null)
              Polyline(
                geodesic: true,
                polylineId: const PolylineId('overview_polyline'),
                color: Theme.of(context).primaryColor,
                width: 6,
                zIndex: 1,
                endCap: Cap.roundCap,
                startCap: Cap.roundCap,
                jointType: JointType.bevel,
                points: directionInfo!.polylinePoints
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList(),
              ),
          },
        );
      },
    );
  }
}
