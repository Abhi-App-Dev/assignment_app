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
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final LocationController locationController =
      Get.put(LocationController());

  @override
  void initState() {
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
    return Scaffold(
        appBar: AppBar(),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            // target: LatLng(33.2464654, 58.146546546),
            target: LatLng(
                double.parse(locationController
                    .currentLocationLatLngList[0].lat
                    .toString()),
                double.parse(locationController
                    .currentLocationLatLngList[0].lng
                    .toString())),
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
