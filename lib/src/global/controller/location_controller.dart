import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  Location location = Location();
  late StreamSubscription<LocationData> locationSubscription;
  Rx<LatLng> currentLocation = LatLng(0, 0).obs;

  Future<void> setInitLocation() async {
    LocationData? locationData;
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    locationData = await location.getLocation();

    double myLat = locationData.latitude!;
    double myLong = locationData.longitude!;

    LatLng initLL = LatLng(myLat, myLong);
    currentLocation.value = initLL;

    listenToChangesInLocation();
  }

  @override
  void onInit() {
    setInitLocation();
    super.onInit();
  }

  @override
  void onClose() {
    locationSubscription.cancel();
    super.onClose();
  }

  void listenToChangesInLocation({void Function(LatLng)? func}) {
    location.onLocationChanged.listen((LocationData cl) async {
      final chgllng = LatLng(cl.latitude!, cl.longitude!);
      currentLocation.value = chgllng;
      // await MyPrefs.saveLoc(chgllng);
    });
  }
}
