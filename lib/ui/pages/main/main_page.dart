import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:secure_step/ui/pages/profile/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/services/background_services.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/location_display.dart';
import '../services/background_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isServiceInitialized = false;
  String? _uuid;
  ValueNotifier<bool> isTracking = ValueNotifier(false);
  final _brandingIcon = const RoundedBrandingSVG(
    iconPath: 'assets/main_page/shield.svg',
    iconSize: 35,
    iconColor: Colors.black,
    fontSize: 25,
  );
  final _avatarIcon = const RoundedIconSVG(
    iconPath: "assets/main_page/avatar.svg",
    size: 35,
    iconColor: Colors.black,
    containerColor: Colors.white,
  );

  final _shieldIcon = const RoundedIconSVG(
    iconPath: "assets/main_page/settings.svg",
    size: 35,
    iconColor: Colors.black,
    containerColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    // Sync isTracking with SharedPreferences
    _syncTrackingState();
    // Set up listeners
    listenToTrackingEvents();
    // Initialize service and UUID
    Future.delayed(const Duration(seconds: 3), () async {
      await _initializeServiceIfNeeded();
      Future.microtask(() => _initializeUniqueIDIfNeeded());
    });
  }

  Future<void> _syncTrackingState() async {
    final prefs = await SharedPreferences.getInstance();
    final isTrackingActive = prefs.getBool('is_tracking_active') ?? false;
    print("🔄 Synced isTracking from SharedPreferences: $isTrackingActive");
    isTracking.value = isTrackingActive;
  }

  void listenToTrackingEvents() {
    final service = FlutterBackgroundService();
    service.isRunning().then((isRunning) {
      print("🔍 Service running status: $isRunning");
    });

    service.on('background_tracking_started').listen((event) async {
      print("✅ Main isolate received 'background_tracking_started' event: $event");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_tracking_active', true);
      isTracking.value = true;
    });

    service.on('background_tracking_stopped').listen((event) async {
      print("✅ Main isolate received 'background_tracking_stopped' event: $event");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_tracking_active', false);
      isTracking.value = false;
    });
  }

  void stopSharingLocation() async {
    print("method 2 called!");
    final service = FlutterBackgroundService();
    service.invoke('stop_sharing_location');
  }

  void startSharingLocation() async {
    print("method 1 called!");
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();
    print("🔍 Service running? $isRunning");
    if (!isRunning) {
      print("⚠️ Service not running, restarting...");
      await initializeService();
    }
    final prefs = await SharedPreferences.getInstance();
    final isTrackingActive = prefs.getBool('is_tracking_active') ?? false;
    if (!isTrackingActive) {
      service.invoke('start-sharing_location');
    } else {
      print("⚠️ Tracking already active, skipping start-sharing_location");
    }
  }

  Future<void> _initializeUniqueIDIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    final existingUUID = prefs.getString('secure_uuid');
    if (existingUUID != null && existingUUID.isNotEmpty) {
      print("✅ UUID retrieved from SharedPreferences: $existingUUID");
      setState(() {
        _uuid = existingUUID;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse('http://192.168.29.50:5000/user/getUID'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final uuid = data['id'];
        print("📥 New UUID fetched from server: $uuid");

        await prefs.setString('secure_uuid', uuid);
        print("💾 UUID stored in SharedPreferences: $uuid");

        setState(() {
          _uuid = uuid;
        });
      } else {
        print("❌ Failed to fetch UID. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 Error fetching UID: $e");
    }
  }

  Future<void> _initializeServiceIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyInitialized = prefs.getBool('service_initialized') ?? false;
    final service = FlutterBackgroundService();

    if (!alreadyInitialized || !(await service.isRunning())) {
      print("🔧 Background service NOT initialized or not running. Initializing now...");
      try {
        await initializeService();
        await prefs.setBool('service_initialized', true);
        setState(() {
          _isServiceInitialized = true;
        });
      } catch (e) {
        print("🔥 Error initializing service: $e");
        await prefs.setBool('service_initialized', false);
      }
    } else {
      print("⚠️ Background service already initialized and running. Skipping...");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CupertinoColors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _brandingIcon,
                Row(
                  children: [
                    BouncyIconButton(
                      onPressed: () {
                        print("Contacts button pressed");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                      icon: _avatarIcon,
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    BouncyIconButton(
                      onPressed: () {
                        print("Settings button pressed");
                      },
                      icon: _shieldIcon,
                    ),
                  ],
                ),
              ],
            ),
            const LocationMap(),
            const SizedBox(height: 30),
            ValueListenableBuilder(
              valueListenable: isTracking,
              builder: (_, tracking, __) {
                print("🔄 UI updating, isTracking: $tracking");
                return tracking
                    ? BouncyIconTextButton(
                  text: "You are being tracked",
                  svgAssetPath: "assets/main_page/trackingIcon.svg",
                  onTap: () {
                    stopSharingLocation();
                  },
                  height: screenHeight * 0.09,
                  width: screenWidth * 0.90,
                  fontSize: 23,
                  iconSize: 25,
                  iconColor: Colors.black,
                  borderRadius: 55,
                  backgroundColor: const Color(0xffffffff),
                )
                    : BouncyIconTextButton(
                  text: "Enable Location Sharing",
                  svgAssetPath: "assets/main_page/enableTracking.svg",
                  onTap: () {
                    startSharingLocation();
                  },
                  height: screenHeight * 0.09,
                  width: screenWidth * 0.90,
                  fontSize: 23,
                  iconSize: 25,
                  iconColor: Colors.black,
                  borderRadius: 55,
                  backgroundColor: const Color(0xffffffff),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}