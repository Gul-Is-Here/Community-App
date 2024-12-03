import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/about_us/about_us.dart';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';
import 'package:community_islamic_app/views/auth_screens/registration_screen.dart';
import 'package:community_islamic_app/views/azan_settings/azan_settings_screen.dart';
import 'package:community_islamic_app/views/contact_us/contact_us_screen.dart';
import 'package:community_islamic_app/views/home_screens/home_screen.dart';
import 'package:community_islamic_app/views/namaz_timmings/namaztimmings.dart';
import 'package:community_islamic_app/views/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../hijri_calendar.dart';
import '../views/home_screens/home.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final isLoggedIn = true.obs;

  final loginController = Get.find<LoginController>();

  final profileController = Get.put(ProfileController());

  Future<void> handleProfileNavigation() async {
    isLoggedIn.value = await loginController.isLoggedIn();
  }

  @override
  void initState() {
    profileController.fetchUserData2();
    profileController.fetchUserData();
    handleProfileNavigation();
    profileController.userData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * .5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 20.heightBox,
            Obx(
              () => Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: screenHeight * .1,
                    width: double.infinity,
                    color: primaryColor,
                  ),
                  Positioned(
                    left: screenWidth * .13,
                    top: 35,
                    child: profileController.userData.isEmpty ||
                            profileController.userData['user'] == null
                        ? Image.asset(
                            aboutUsIcon,
                            width: 80,
                            height: 80,
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                                border: Border.all(width: 2),
                                color: Colors.black),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                profileController.userData['user']
                                    ['profile_image'],
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 50),
              child: Obx(() {
                if (profileController.userData.isEmpty ||
                    profileController.userData['user'] == null) {
                  // If userData is null or empty, show default text
                  return Center(
                    child: const Text(
                      'Guest',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: popinsSemiBold,
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                } else {
                  // Show the user's name if userData is loaded and valid
                  return Center(
                    child: Text(
                      'Hello, ${profileController.userData['user']['name']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                }
              }),
            ),
            Obx(
              () => isLoggedIn.value
                  ? Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: profileController.userData['user'] == null
                          ? SizedBox()
                          : Text(
                              'View Profile',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: popinsRegulr),
                            ).onTap(() async {
                              await Get.to(() => ProfileScreen());
                            }),
                    )
                  : const SizedBox(),
            ),
            const Divider(color: Colors.black),
            // ListTile(
            //   leading: Icon(Icons.calendar_month, color: primaryColor),
            //   title: const Text('Hijri Calendar',
            //       style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
            //   onTap: () {
            //     Get.to(() => const HijriCalendarExample());
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.calendar_month, color: primaryColor),
            //   title: const Text('View Times',
            //       style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
            //   onTap: () {
            //     Get.to(() => const NamazTimingsScreen());
            //   },
            // ),
            // const Divider(),
            Obx(() => isLoggedIn.value &&
                    profileController.userData['user'] != null
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
              return isLoggedIn.value &&
                      profileController.userData['user'] != null
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
            ListTile(
              leading: Icon(Icons.share, color: primaryColor),
              title: const Text('About Us',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                Get.to(() => AboutUsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: primaryColor),
              title: const Text('Share the App',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                // Handle app sharing
              },
            ),
            ListTile(
              leading: Icon(Icons.handshake_outlined, color: primaryColor),
              title: const Text('Our Promise',
                  style: TextStyle(fontFamily: popinsRegulr, fontSize: 14)),
              onTap: () {
                // Navigate to a proper screen for "Our Promise"
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
