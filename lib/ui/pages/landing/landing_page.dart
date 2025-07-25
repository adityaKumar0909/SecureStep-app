import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'onboard_one.dart';
import 'onboard_two.dart';
import 'onboard_three.dart'; // The one with permission info

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with your 3 onboarding screens
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              OnboardingPage1(),
              OnboardingPage2(),
              OnboardingPage3(),
            ],
          ),

          // Positioned worm indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: Colors.red,
                  dotColor: Colors.black26,
                ),
              ),
            ),
          ),

          // Skip / Next / Done buttons
          Positioned(
            bottom: 30,
            right: 20,
            child: onLastPage
                ? ElevatedButton(
              onPressed: () {
                // Navigate to main app or homepage
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // 🔴 Red pill
                foregroundColor: Colors.white, // ⚪ White text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // pill shaped
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Get Started",style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
            )
                : TextButton(
              onPressed: () {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Next",style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            child:onLastPage ? Container() : TextButton(
              onPressed: () {
                _controller.jumpToPage(2);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Skip",style: GoogleFonts.outfit(
              fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
