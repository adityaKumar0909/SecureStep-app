import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:secure_step/core/services/location_service.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool detectorStarted = false;
bool isTrackingStarted = false;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'safehaven',
    'Foreground Service',
    description: 'Used for important background functioning',
    importance: Importance.high,
    playSound: false,
  );

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: androidSettings);
  try {
    await flutterLocalNotificationsPlugin.initialize(settings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print("🛠️ Configuring background service...");
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: 'safehaven',
        initialNotificationTitle: 'Safehaven Active',
        initialNotificationContent: 'Initializing background monitoring...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(),
    );

    print("🚀 Starting background service...");
    await service.startService();
  } catch (e) {
    print("🔥 Error initializing background service: $e");
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin bgNotifications =
  FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: androidSettings);
  await bgNotifications.initialize(settings);

  // Load initial tracking state from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  isTrackingStarted = prefs.getBool('is_tracking_active') ?? false;
  print("🔄 Background isolate loaded isTrackingStarted: $isTrackingStarted");



  service.on("start-sharing_location").listen((event) async {
    print("📦 Background isolate received 'start-sharing_location': $event");
    if (!isTrackingStarted) {
      isTrackingStarted = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_tracking_active', true);
      print("🚀 Location sharing started in background isolate");
      await startLocationPolling();
      print("📤 Sending 'background_tracking_started' to main isolate");
      service.invoke("background_tracking_started");
    } else {
      print("⚠️ Tracking already active, skipping start-sharing_location");
    }
  });

  service.on("stop_sharing_location").listen((event) async {
    print("📦 Background isolate received 'stop_sharing_location': $event");
    if (isTrackingStarted) {
      isTrackingStarted = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_tracking_active', false);
      await stopLocationPolling();
      print("📤 Sending 'background_tracking_stopped' to main isolate");
      service.invoke("background_tracking_stopped");
    } else {
      print("⚠️ Tracking already stopped, skipping stop_sharing_location");
    }
  });

  if (service is AndroidServiceInstance &&
      await service.isForegroundService() &&
      !detectorStarted) {
    detectorStarted = true;
    ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) async {
        if (!isTrackingStarted) {
          // Fluttertoast.showToast(
          //   msg: "Shake detected 📢",
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          // );
          if (await Vibration.hasVibrator() ?? false) {
            if (await Vibration.hasCustomVibrationsSupport() ?? false) {
              Vibration.vibrate(duration: 1500);
              await Future.delayed(Duration(milliseconds: 500));
              Vibration.vibrate(duration: 1500);
            } else {
              Vibration.vibrate(duration: 4000);
            }
          }
          isTrackingStarted = true;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_tracking_active', true);
          print("📤 Shake triggered 'background_tracking_started'");
          service.invoke('background_tracking_started');
        }
      },
      shakeThresholdGravity: 8.0,
      shakeSlopTimeMS: 300,
      shakeCountResetTime: 2000,
      minimumShakeCount: 2,
    );

    await bgNotifications.show(
      888,
      'Safehaven Active',
      'Listening for emergency shake',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'safehaven',
          'Foreground Service',
          icon: '@mipmap/ic_launcher',
          ongoing: true,
          importance: Importance.high,
          autoCancel: false,
        ),
      ),
    );
  }

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance &&
        !(await service.isForegroundService())) {
      timer.cancel();
    }
  });
}