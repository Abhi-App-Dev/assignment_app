// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/location_permission.dart';

class LocationController extends GetxController {
  var isLocationGranted = false.obs;
  var isTracking = false.obs;
  var timer = 0.obs;
  var currentLocationLatLngList = <LatLng>[].obs;

  @override
  void onReady() {
    permissionStatus();
    super.onReady();
  }

  permissionStatus() async {
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
      currentLocationLatLngList
          .add(LatLng(value.latitude, value.longitude));
      Timer(Duration(seconds: 10), () {
        isTracking.isTrue
            ? getCurrentLocation()
            : SizedBox();
      });
    });
  }
}
