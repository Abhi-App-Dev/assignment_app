// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:demoapp/database/database.dart';
import 'package:demoapp/model/user_location_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/location_permission.dart';

class LocationController extends GetxController {
  var isLocationGranted = false.obs;
  var isTracking = false.obs;
  var timer = 0.obs;
  var currentLocationLatLngList = <Location>[].obs;
  var locationLatLng = <LatLng>[].obs;

  @override
  void onReady() {
    permissionStatus();
    super.onReady();
  }

  permissionStatus() async {
    print("location permission method calling...");
    var isGrant =
        await FetchLocation().getLocationPermission();
    if (isGrant == true) {
      isLocationGranted.value = true;
      getCurrentLocation();
    } else {
      isLocationGranted.value = false;
    }
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy:
                LocationAccuracy.bestForNavigation)
        .then((value) {
      isTracking.isTrue
          ? Timer(Duration(seconds: 2), () {
              locationLatLng.add(
                  LatLng(value.latitude, value.longitude));
              DBHelper.insert(
                  'location',
                  Location(
                      lat: value.latitude.toString(),
                      lng: value.longitude.toString()));
              getCurrentLocation();
            })
          : setData;
    });
  }

  setData() async {
    currentLocationLatLngList.clear();
    print("Data fetching...");
    print(
        "Length of currentLocationLatLng:==>${currentLocationLatLngList.length}");
    currentLocationLatLngList.value =
        (await DBHelper.get('location'))!;
    print(
        "Length of currentLocationLatLng:==>${currentLocationLatLngList.length}");
  }
}
