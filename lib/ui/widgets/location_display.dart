import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  GoogleMapController? mapController;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 16),
        );
      }
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Center(
        child: _currentLocation == null
            ? const CircularProgressIndicator()
            : SizedBox(
          width: screenWidth * 0.93,
          height: screenHeight * 0.60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 16,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),
        ),
      ),
    );
  }
}
