// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:collection';

import 'package:demoapp/controller/location_controller.dart';
import 'package:demoapp/database/database.dart';
import 'package:demoapp/view/google_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target:
          LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  final Set<Marker> _marker = {};
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final LocationController locationController =
      Get.put(LocationController());
  var isTracking = true.obs;

  @override
  void initState() {
    isTracking.value = true;
    _polygon.add(const Polygon(
      polygonId: PolygonId("1"),
      points: [],
      fillColor: Colors.blueGrey,
      geodesic: true,
      strokeWidth: 2,
    ));
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
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
                      margin: EdgeInsets.symmetric(
                          vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20),
                        color: const Color(0xff668cff),
                      ),
                      child: Center(
                        child: Text(
                          locationController
                                  .isTracking.isTrue
                              ? "Tracking On"
                              : "Tracking Off",
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xffFFFFFF)),
                        ),
                      ),
                    ),
                  ),

                  (locationController.isTracking.isFalse &&
                          locationController
                              .locationLatLng.isNotEmpty)
                      ? SizedBox(
                          height: Get.width,
                          width: Get.width,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition:
                                CameraPosition(
                              target: locationController
                                  .locationLatLng[0],
                              // target: LatLng(
                              //     double.parse(
                              //         locationController
                              //             .currentLocationLatLngList[
                              //                 0]
                              //             .lat
                              //             .toString()),
                              //     double.parse(
                              //         locationController
                              //             .currentLocationLatLngList[
                              //                 0]
                              //             .lng
                              //             .toString())),
                              zoom: 20,
                            ),
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            polygons: _polygon,
                            onMapCreated:
                                (GoogleMapController
                                    controller) {
                              _controller
                                  .complete(controller);
                            },
                          ),
                        )
                      : SizedBox(),

                  ...locationController
                      .currentLocationLatLngList.value
                      .asMap()
                      .entries
                      .map((e) => RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      "Lat: ${e.value.lat}",
                                  style: TextStyle(
                                      color: Colors
                                          .blueAccent)),
                              TextSpan(
                                  text:
                                      "\t\tLng: ${e.value.lng}",
                                  style: TextStyle(
                                      color:
                                          Colors.blueGrey)),
                            ]),
                          )),
                ],
              ),
            ),
          ),
        ));
  }

  getLocationNow() {
    if (locationController.isTracking.isTrue) {
      DBHelper.deleteTable();
      locationController.getCurrentLocation();
    } else {
      locationController.setData();
    }
    print(
        "Tracking status:==>${locationController.isTracking.value}");
  }
}
