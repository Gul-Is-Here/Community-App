import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
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
  CustomDrawer({super.key});
  var isLoggedIn = true.obs;
  Future<void> handleProfileNavigation() async {
    final loginController = Get.find<LoginController>();
    isLoggedIn.value = await loginController.isLoggedIn();
  }

  final loginController = Get.find<LoginController>();
  final profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    print('Login Status: ${loginController.isLoggedIn()}');
    profileController.fetchUserData2();
    handleProfileNavigation();
    print('Drawer Pressed');

    return Drawer(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.heightBox,
            Container(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  aboutUsIcon,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Obx(() {
                return Text(
                  isLoggedIn.value
                      ? 'Hello, ${profileController.userData['user']['name']}'
                      : 'Guest',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                );
              }),
            ),
            Obx(
              () => isLoggedIn.value
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Text(
                        'View Profile',
                        style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: popinsRegulr),
                      ).onTap(() async {
                        await Get.to(() => const ProfileScreen());
                      }),
                    )
                  : const SizedBox(),
            ),

            const Divider(color: Colors.black),

            // ListTile(
            //   leading: Icon(Icons.home, color: primaryColor),
            //   title: const Text('Home',
            //       style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
            //   onTap: () {
            //     Get.to(() => const Home());
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.calendar_month, color: primaryColor),
              title: const Text('Hijri Calender',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => const HijriCalendarExample());
              },
            ),
            const Divider(),
            Obx(() => isLoggedIn.value
                ? const SizedBox()
                : ListTile(
                    leading: Icon(Icons.app_registration, color: primaryColor),
                    title: const Text('Register',
                        style:
                            TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
                    onTap: () {
                      Get.to(() => RegistrationScreen());
                    },
                  )),
            Obx(() {
              return isLoggedIn.value
                  ? ListTile(
                      leading: Icon(Icons.logout, color: primaryColor),
                      title: const Text('Logout',
                          style: TextStyle(
                              fontFamily: popinsRegulr, fontSize: 14)),
                      onTap: () async {
                        await loginController.logoutUser();
                        Get.to(() => LoginScreen());
                      },
                    )
                  : ListTile(
                      leading: Icon(Icons.login, color: primaryColor),
                      title: const Text('Login',
                          style: TextStyle(
                              fontFamily: popinsRegulr, fontSize: 14)),
                      onTap: () {
                        Get.to(() => LoginScreen());
                      },
                    );
            }),
            const Divider(),
            ListTile(
              leading: Icon(Icons.timelapse, color: primaryColor),
              title: const Text('Notification',
                  style: TextStyle(fontSize: 14, fontFamily: popinsRegulr)),
              onTap: () {
                Get.to(() => const AzanSettingsScreen());
              },
            ),
            // const Divider(),
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
            const Spacer(),
            const Divider(),
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
