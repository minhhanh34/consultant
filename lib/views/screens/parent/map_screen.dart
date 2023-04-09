import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.geoPoint});
  final GeoPoint geoPoint;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controller = Completer<GoogleMapController>();

  late CameraPosition _cameraPosition;

  late List<Marker> _makers;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude),
      zoom: 12,
    );
    _makers = <Marker>[
      Marker(
        markerId: MarkerId(widget.geoPoint.toString()),
        position: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude),
      )
    ];
  }

  Future<void> requestPermission() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) return;
      }

      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) return;
      }
    } catch (e) {
      log('error', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
            future: requestPermission(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: _cameraPosition,
                      onMapCreated: (controller) {
                        _controller.complete(controller);
                      },
                      markers: Set.of(_makers),
                      // circles: Set.of(circles),
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      buildingsEnabled: true,
                      mapToolbarEnabled: true,
                      // onTap: (pos) {
                      //   _controller.future.then((controller) {
                      //     controller.showMarkerInfoWindow(MarkerId('a'));
                      //   });
                      // },
                      // liteModeEnabled: true,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ],
                );
              }
              return const CenterCircularIndicator();
            }),
      ),
    );
  }
}
