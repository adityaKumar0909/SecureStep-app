import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.06,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.20),

            Center(
              child: SvgPicture.asset(
                'assets/landing_page/shake.svg',
                height: screenHeight * 0.2,
                width: screenHeight * 0.2,
                semanticsLabel: 'Safety Icon',
                color: Colors.red,
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // Subtitle slogan with Outfit font
            Text(
              "With a simple chop or shake of your phone, SecureStep instantly sends your live location to your trusted contacts.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: screenWidth * 0.06, // Slightly smaller for better fit
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // Stronger statement with Poppins font
            Text(
              "Works silently. Runs 24/7.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.075,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
