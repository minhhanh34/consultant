import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.geoPoint});
  final GeoPoint geoPoint;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controller = Completer<GoogleMapController>();

  // static const hcmPosition = LatLng(10.8371748, 106.6171188);

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

  // void getLocation() async {
  //   final location = Location();
  //   bool serviceEnabled;
  //   LocationData locationData;
  //   PermissionStatus permissionStatus;

  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.serviceEnabled();
  //     if (!serviceEnabled) return;
  //   }

  //   permissionStatus = await location.requestPermission();
  //   if (permissionStatus == PermissionStatus.denied) {
  //     permissionStatus = await location.requestPermission();
  //     if (permissionStatus != PermissionStatus.granted) return;
  //   }

  //   locationData = await location.getLocation();

  //   getMaker(locationData);
  // }

  // void getMaker(LocationData locationData) async {
  // final respones = await http.get(
  //   Uri.parse(
  //       '$placeUrl&type=restaurant&location=${locationData.altitude},${locationData.latitude}&radius=10000'),
  // );
  // if (respones.statusCode == 200) {
  //   final data = jsonDecode(respones.body);
  //   print(data);
  //   List places = data['results'];
  //   makers.clear();
  //   places.forEach(
  //     (place) => makers.add(
  //       Marker(
  //         markerId: place['reference'],
  //         position: LatLng(
  //           place['geometry']['location']['lat'],
  //           place['geometry']['location']['lng'],
  //         ),
  //       ),
  //     ),
  //   );
  //   print('toi day ne');
  //   setState(() {});
  //   // }
  //   makers
  //     ..clear()
  //     ..add(
  //       Marker(
  //         markerId: const MarkerId('current position'),
  //         position: LatLng(locationData.latitude!, locationData.longitude!),
  //       ),
  //     );
  //   circles
  //     ..clear
  //     ..add(Circle(
  //         circleId: const CircleId('current circle'),
  //         center: LatLng(locationData.latitude!, locationData.longitude!),
  //         radius: 4000));
  //   setState(() {});
  //   _controller.future.then((controller) {
  //     controller.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: makers[0].position,
  //           zoom: 14,
  //         ),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
              // zoomControlsEnabled: true,
              // mapToolbarEnabled: true,
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
        ),
      ),
    );
  }
}
