// ignore_for_file: prefer_const_constructors

import 'package:demoapp/controller/location_controller.dart';
import 'package:demoapp/view/google_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationController locationController =
      Get.put(LocationController());
  var isTracking = true.obs;

  @override
  void initState() {
    isTracking.value = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Location Tracking",
              style: TextStyle(fontSize: 20)),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => GoogleMapWithMarker());
              },
              child: Icon(Icons.map),
            )
          ],
        ),
        body: Obx(
          () => SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (locationController
                        .isLocationGranted.isFalse)
                    ? Text(
                        "Please allow Location",
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                Text(
                  "lat lnt list length:==> ${locationController.currentLocationLatLngList.length}",
                  style: TextStyle(color: Colors.red),
                ),
                //button
                GestureDetector(
                  onTap: () {
                    locationController
                            .isLocationGranted.isTrue
                        ? locationController.isTracking
                            .toggle()
                        : locationController
                            .permissionStatus();

                    getLocationNow();
                  },
                  child: Container(
                    width: size.width * 0.5,
                    margin:
                        EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20),
                      color: const Color(0xff668cff),
                    ),
                    child: Center(
                      child: Text(
                        locationController.isTracking.isTrue
                            ? "Tracking On"
                            : "Tracking Off",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xffFFFFFF)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  getLocationNow() {
    if (locationController.isTracking.isTrue) {
      locationController.getCurrentLocation();
    }
    print(
        "Tracking status:==>${locationController.isTracking.value}");
  }
}
