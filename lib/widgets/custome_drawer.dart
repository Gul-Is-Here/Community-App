import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';
import 'package:community_islamic_app/views/auth_screens/registration_screen.dart';
import 'package:community_islamic_app/views/azan_settings/azan_settings_screen.dart';
import 'package:community_islamic_app/views/contact_us/contact_us_screen.dart';
import 'package:community_islamic_app/views/home_screens/home_screen.dart';
import 'package:community_islamic_app/views/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../hijri_calendar.dart';
import '../views/home_screens/home.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _handleProfileNavigation() async {
    final loginController = Get.find<LoginController>();
    final isLoggedIn = await loginController.isLoggedIn();

    if (isLoggedIn) {
      Get.to(() => ProfileScreen());
    } else {
      Get.to(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure you are using the same instance of LoginController that was used for the check
    final loginController = Get.find<LoginController>();

    return Drawer(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo at the Top
            20.heightBox,
            Container(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  aboutUsIcon, // Path to your logo image
                  width: 80,
                  height: 80,
                ),
              ),
            ),

            // Optionally display user info if logged in
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(() {
                return Text(
                  loginController.email.value.isNotEmpty
                      ? 'Hello, ${loginController.email.value}'
                      : 'Guest',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                );
              }),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'View Profile',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ).onTap(() async {
              await _handleProfileNavigation();
            }),

            const Divider(
              color: Colors.black,
            ),
            //Prayer Notification
            ListTile(
              leading: Icon(Icons.timelapse, color: primaryColor),
              title: const Text('Notification',
                  style: TextStyle(fontSize: 14, fontFamily: popinsRegulr)),
              onTap: () {
                Get.to(() => const AzanSettingsScreen());
              },
            ),
            // Home
            ListTile(
              leading: Icon(Icons.home, color: primaryColor),
              title: const Text('Home',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => const Home());
              },
            ),
            // Hijiri Calendar
            ListTile(
              leading: Icon(Icons.calendar_month, color: primaryColor),
              title: const Text('Hijri Calender',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => const HijriCalendarExample());
              },
            ),
            const Divider(), // Divider lin
            //Settings
            ListTile(
              leading: Icon(Icons.app_registration, color: primaryColor),
              title: const Text('Register',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => RegistrationScreen());
              },
            ),
            // Login
            ListTile(
              leading: Icon(Icons.login, color: primaryColor),
              title: const Text('Login',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => LoginScreen());
              },
            ),
            const Divider(), // Divider lin
            ListTile(
              leading: Icon(Icons.share, color: primaryColor),
              title: const Text('Share the App',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => const AzanSettingsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.handshake_outlined, color: primaryColor),
              title: const Text('Our Promise',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => const AzanSettingsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_page, color: primaryColor),
              title: const Text('Contact Us',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => const ContactUsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: primaryColor),
              title: const Text('Logout',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () async {
                await loginController.logoutUser();
                Get.to(() => LoginScreen());
              },
            ),
            const Spacer(), // Pushes items to the top
            const Divider(), // Divider line
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '© 2024 Your Company',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
