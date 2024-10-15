import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/home_screens/masjid_map/order_traking_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapSplashScreen extends StatefulWidget {
  @override
  _MapSplashScreenState createState() => _MapSplashScreenState();
}

class _MapSplashScreenState extends State<MapSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainApp();
  }

  _navigateToMainApp() async {
    // Simulate a delay (e.g., loading resources, initialization, etc.)
    await Future.delayed(const Duration(seconds: 3), () {
      Get.off(() =>
          const OrderTrackingPage()); // Navigate to the main app and clear the stack
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation from the splash screen
        return false; // Returning false prevents the pop
      },
      child: Stack(
        children: [
          // Set the image to cover the entire screen
          Positioned.fill(
            child: Image.asset(
              splashBg,
              fit: BoxFit.cover, // Ensures the image covers the whole screen
            ),
          ),
          // Center the text on the screen
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * .4),
            child: Center(
              child: Text(
                'Welcome to\n Rosenberg Community Center',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0, // Adjust font size as per your design
                  fontFamily: popinsSemiBold,
                  color: Color(0xFF6CA3A6), // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
