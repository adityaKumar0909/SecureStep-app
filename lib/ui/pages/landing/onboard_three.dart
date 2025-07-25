import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

// Import your main page here
import 'package:secure_step/ui/pages/main/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- replace with your actual path

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});


  Future<void> _requestPermissions(BuildContext context) async {
    print("Button pressed !");

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
      Permission.ignoreBatteryOptimizations,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (allGranted) {

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All permissions granted ✅")),
      );

      // Navigate to MainPage
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Some permissions were denied ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.20),

                  Center(
                    child: SvgPicture.asset(
                      'assets/landing_page/hand.svg',
                      height: screenHeight * 0.2,
                      width: screenHeight * 0.2,
                      semanticsLabel: 'Safety Icon',
                      color: Colors.red,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  Text(
                    "To protect you, we need your trust.",
                    style: GoogleFonts.outfit(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  Text(
                    "To ensure SecureStep works as intended, we kindly request a few essential permissions shortly. Without them, some features may not function properly.",
                    style: GoogleFonts.outfit(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _requestPermissions(context),
                      icon: const Icon(Icons.lock_open, size: 25),
                      label: const Text("Grant Permissions"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
