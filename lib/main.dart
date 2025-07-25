import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_step/ui/pages/landing/landing_page.dart';
import 'package:secure_step/ui/pages/landing/landing_page.dart';
import 'package:secure_step/ui/pages/landing/onboard_three.dart';
import 'package:secure_step/ui/pages/main/main_page.dart';
import 'package:secure_step/ui/pages/profile/profile_page.dart';
import 'package:secure_step/ui/pages/splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_step/ui/pages/landing/onboard_one.dart';
import 'package:secure_step/ui/pages/landing/onboard_two.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final prefs = await SharedPreferences.getInstance();
  // final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SecureStep',
      home:  SplashScreen(),
    );
  }
}
