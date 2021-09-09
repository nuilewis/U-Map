
import 'package:location/location.dart';

LocationData? currentPosition;
Location location = Location();

/// get location function
getLocation() async {
  /// getting current position
  currentPosition = await location.getLocation();

  ///listening for location changes
  location.onLocationChanged.listen(
        (LocationData currentLocation) {
      currentPosition = currentLocation;
      //return currentLocation;
    },
  );

  return currentPosition;
}

