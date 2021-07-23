import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await Geolocator.openLocationSettings();
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    showSnackBar(context, LOCATION_DISABLED);
    return Future.error(LOCATION_DISABLED);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      showSnackBar(context, LOCATION_PERMISSION_ERR);
      return Future.error(LOCATION_PERMISSION_ERR);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    showSnackBar(context,
        LOCATION_PERMISSION_DENIED_ERR);
    return Future.error(
        LOCATION_PERMISSION_DENIED_ERR);
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best)
      .then((value) {
    //FireStore.updateUserCurrentLocation(uid, value);
    //showSnackBar(context, LOCATION_UPDATED_SUCCESS);
    return value;
  });
}

Future<String> getAddressFromLatLng(double lat, double lng) async {
  try {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placeMarks[0];
    return "${place.locality}, ${place.postalCode}, ${place.country}";
  } catch (e) {
    print(e);
    return "";
  }
}
