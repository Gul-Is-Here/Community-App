import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';
import 'package:community_islamic_app/views/home_screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAppropriateScreen();
  }

  Future<void> _navigateToAppropriateScreen() async {
    // Simulate a delay (e.g., loading resources, initialization, etc.)
    await Future.delayed(Duration(seconds: 3)); // Adjust the duration as needed

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Navigate to Home screen if user is logged in
      Get.offAll(() => Home());
    } else {
      // Navigate to Login screen if user is not logged in
      Get.offAll(() => Home());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
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
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'First Islamic Dawah Center In Rosenberg Texas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0, // Adjust font size as per your design
                    fontFamily: popinsMedium,
                    color: Color(0xFF6CA3A6), // Text color
                    // Bold text
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
