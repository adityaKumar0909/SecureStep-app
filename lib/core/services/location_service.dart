
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:async';

Timer? locationPollingTimer;

Future<void> startLocationPolling() async {
  // Cancel previous timer if any
  locationPollingTimer?.cancel();

  locationPollingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
    print("📡 Polling for location...");
    await ShareLocationWithServer();
  });
}

Future<void> stopLocationPolling() async {
  locationPollingTimer?.cancel();
}

Future<void> ShareLocationWithServer()async {

  print("⚓ Inside share location function");


  //Let's get the UUID from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final uuid = prefs.getString('secure_uuid');
  print("UUID: $uuid");
  //Let's fetch our location from geolocator package

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("📍 Lat: ${position.latitude}, Lon: ${position.longitude}");
    final lat = position.latitude;
    final lon = position.longitude;
    //Let's send the location to the server
  const String apiUrl = 'http://192.168.29.50:5000/location/location-update';
  try{
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer yourToken', // If your API needs auth
      },
      body: jsonEncode({
        'lat': lat,
        'lon': lon,
        'uuid': uuid,
      }),
    );
    if (response.statusCode == 201) {
      print('✅ Location sent successfully');
    } else {
      print('❌ Server error: ${response.statusCode}');
    }
  }catch(err){
    print("Error: $err");
  }

}