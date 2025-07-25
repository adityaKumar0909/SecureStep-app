import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return const Scaffold(
      backgroundColor: Colors.white,
      body: _OnboardingContent(),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.40),

              // Row with title and SVG
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SecureStep",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  SvgPicture.asset(
                    'assets/landing_page/appLogo.svg',
                    height: screenHeight * 0.06,
                    width: screenHeight * 0.06,
                    semanticsLabel: 'Safety Icon',
                    color: Colors.red,
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.015),

              Text(
                "Not just an app. Your invisible guard.",
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
