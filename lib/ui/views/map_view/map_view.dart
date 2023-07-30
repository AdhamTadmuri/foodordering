import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_ordering_sp2/core/enums/request_status.dart';
import 'package:food_ordering_sp2/ui/views/map_view/map_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  final LocationData currentLocation;
  const MapView({super.key, required this.currentLocation});
  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MapController(widget.currentLocation),
        builder: (mapController) {
          return Scaffold(
            body: GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: mapController.currentPosition,
              onMapCreated: (GoogleMapController controller) async {
                mapController.controller.complete(controller);

                mapController.addMarker(
                    imageName: 'pin.png',
                    position: LatLng(
                        widget.currentLocation.latitude ?? 37.42796133580664,
                        widget.currentLocation.longitude ?? -122.085749655962),
                    id: 'current');
              },
              markers: mapController.markers,
              onTap: (latlong) {
                mapController.selecteLocation = latlong;

                mapController.addMarker(
                    imageUrl: 'https://www.fluttercampus.com/img/car.png',
                    position: LatLng(latlong.latitude, latlong.longitude),
                    id: 'current');
              },
            ),
            floatingActionButton:
                mapController.requestStatus == RequestStatus.LOADING
                    ? CircularProgressIndicator()
                    : FloatingActionButton.extended(
                        onPressed: _goToTheLake,
                        label: Text(mapController.streetName.value),
                        icon: const Icon(Icons.directions_boat),
                      ),
          );
        });
  }

  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class MapView2 extends StatefulWidget {
  final LocationData currentLocation;
  const MapView2({super.key, required this.currentLocation});

  @override
  State<MapView> createState() => MapViewState();
}

class MapView2State extends State<MapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _currentPosition;

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    _currentPosition = CameraPosition(
      target: LatLng(widget.currentLocation.latitude ?? 37.42796133580664,
          widget.currentLocation.longitude ?? -122.085749655962),
      zoom: 14.4746,
    );
    selecteLocation = LatLng(
        widget.currentLocation.latitude ?? 37.42796133580664,
        widget.currentLocation.longitude ?? -122.08574965596);
    super.initState();
  }

  Set<Marker> markers = {};

  late LatLng selecteLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _currentPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          markers.add(Marker(
              markerId: MarkerId('current'),
              position: LatLng(
                  widget.currentLocation.latitude ?? 37.42796133580664,
                  widget.currentLocation.longitude ?? -122.085749655962)));

          setState(() {});
        },
        markers: markers,
        onTap: (latlong) {
          selecteLocation = latlong;
          markers.add(Marker(
              markerId: MarkerId('current'),
              position: LatLng(latlong.latitude, latlong.longitude)));

          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
