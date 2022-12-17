import 'dart:async';
import 'dart:collection';

import 'package:demoapp/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWithMarker extends StatefulWidget {
  const GoogleMapWithMarker({Key? key}) : super(key: key);

  @override
  State<GoogleMapWithMarker> createState() =>
      _GoogleMapWithMarkerState();
}

class _GoogleMapWithMarkerState
    extends State<GoogleMapWithMarker> {
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
  Set<Polygon> _polygon = HashSet<Polygon>();

  // List<LatLng> points = [
  //   LatLng(33.2464654, 58.146546546),
  //   LatLng(33.2464654, 58.142424),
  //   LatLng(32.2464654, 57.146546546),
  //   LatLng(33.2464654, 58.146546546),
  //   LatLng(33.2464654, 58.146546546),
  //   LatLng(33.2464654, 58.146546546),
  // ];

  final LocationController locationController =
      Get.put(LocationController());

  @override
  void initState() {
    _polygon.add(Polygon(
      polygonId: const PolygonId("1"),
      points: locationController.currentLocationLatLngList,
      fillColor: Colors.blueGrey,
      geodesic: true,
      strokeWidth: 2,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            // target: LatLng(33.2464654, 58.146546546),
            target: LatLng(
                locationController
                    .currentLocationLatLngList[0].latitude,
                locationController
                    .currentLocationLatLngList[0]
                    .longitude),
            zoom: 20,
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          polygons: _polygon,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
  }
}
