import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateUserProfileInServer() async{

  print("✨Inside update user profile function✨");
  //Let's get all the values we have to update in server
  final prefs = await SharedPreferences.getInstance();
  final uuid = prefs.getString('secure_uuid');
  final email = prefs.getString('email');
  final name = prefs.getString('name');
  final emergencyContacts = prefs.getStringList('emergencyContacts');

  // Null check
  if (uuid == null || email == null || name == null || emergencyContacts == null) {
    print("⚠️ One or more fields are missing. Cannot update profile.");
    return;
  }

  const String apiUrl = 'http://192.168.29.50:5000/user/updateUserProfile';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uuid': uuid,
        'email': email,
        'name': name,
        'emergencyContacts': emergencyContacts,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ User profile updated successfully');
    } else {
      print('❌ Server responded with ${response.statusCode}: ${response.body}');
    }
  } catch (err) {
    print('❌ Error sending profile to server: $err');
    Fluttertoast.showToast(
      msg: "Error sending profile to server",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

}