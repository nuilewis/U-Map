import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'directions_model.dart';
import 'directions_repository.dart';

Directions? directionInfo;

///Get Directions func
getDirections(LatLng origin, LatLng destination) async {
  final directions = await DirectionsRepository()
      .getDirections(origin: origin, destination: destination);

  directionInfo = directions;

  return directionInfo;
}
