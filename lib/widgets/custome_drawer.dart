import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/about_us/about_us.dart';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';
import 'package:community_islamic_app/views/auth_screens/registration_screen.dart';
import 'package:community_islamic_app/views/azan_settings/azan_settings_screen.dart';
import 'package:community_islamic_app/views/contact_us/contact_us_screen.dart';
import 'package:community_islamic_app/views/home_screens/home_screen.dart';
import 'package:community_islamic_app/views/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';

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
    print('token');
    print(globals.accessToken.value);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: primaryColor,
      width: screenWidth * .8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 20.heightBox,
            Stack(
              clipBehavior: Clip.none,
              children: [
                // 50.heightBox,
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      aboutUsIcon,
                      width: 121,
                      height: 121,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 50),
              child: Obx(() {
                if (profileController.userData.isEmpty ||
                    profileController.userData['user'] == null) {
                  // If userData is null or empty, show default text
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  color: lightColor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Icon(Icons.person),
                            ),
                            // 10.widthBox
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => LoginScreen());
                                      },
                                      child: Text(
                                        '   Login/',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: popinsMedium,
                                          color: whiteColor,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => RegistrationScreen());
                                      },
                                      child: Text(
                                        'Resgister',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: popinsMedium,
                                          color: whiteColor,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    textDirection: TextDirection.ltr,
                                    'Guest',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: popinsRegulr,
                                      color: whiteColor,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Show the user's name if userData is loaded and valid
                  return Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                    border: Border.all(width: 2),
                                    color: lightColor),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    profileController.userData['user']
                                        ['profile_image'],
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                              ),
                              // 10.widthBox,
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '  ${profileController.userData['user']['name']}',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontFamily: popinsMedium,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '   ${profileController.userData['user']['email']}',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontFamily: popinsRegulr,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              // 3.widthBox,
                              SizedBox(
                                height: 3,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await Get.to(() => ProfileScreen());
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: lightColor,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ),
            // Obx(
            //   () => isLoggedIn.value
            //       ? Padding(
            //           padding: const EdgeInsets.only(left: 25),
            //           child: profileController.userData['user'] == null
            //               ? const SizedBox()
            //               : Text(
            //                   'View Profile',
            //                   style: TextStyle(
            //                       decoration: TextDecoration.underline,
            //                       color: whiteColor,
            //                       fontSize: 12,
            //                       fontFamily: popinsRegulr),
            //                 ).onTap(() async {}),
            //         )
            //       : const SizedBox(),
            // ),
            // 10.heightBox,
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Divider(color: Color(0xFF22554F)),
            ),
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

            ListTile(
              leading: Image.asset(
                dNotificationIcon,
                height: 24,
                width: 24,
              ),
              title: Text('Notification',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: popinsRegulr,
                      color: whiteColor)),
              onTap: () {
                Get.to(() => const AzanSettingsScreen());
              },
            ),
            ListTile(
              leading: Image.asset(
                dAboutUsIcon,
                height: 24,
                width: 24,
              ),
              title: Text('About Us',
                  style: TextStyle(
                      fontFamily: popinsRegulr,
                      fontSize: 14,
                      color: whiteColor)),
              onTap: () {
                Get.to(() => AboutUsScreen());
              },
            ),
            ListTile(
              leading: Image.asset(
                dShareIcon,
                height: 24,
                width: 24,
              ),
              title: Text('Share the App',
                  style: TextStyle(
                      fontFamily: popinsRegulr,
                      fontSize: 14,
                      color: whiteColor)),
              onTap: () {
                // Handle app sharing
              },
            ),
            ListTile(
              leading: Image.asset(
                dourPromise,
                height: 24,
                width: 24,
              ),
              title: Text('Our Promise',
                  style: TextStyle(
                      fontFamily: popinsRegulr,
                      fontSize: 14,
                      color: whiteColor)),
              onTap: () {
                // Navigate to a proper screen for "Our Promise"
              },
            ),
            ListTile(
              leading: Image.asset(
                dContactUs,
                height: 24,
                width: 24,
              ),
              title: Text('Contact Us',
                  style: TextStyle(
                      fontFamily: popinsRegulr,
                      fontSize: 14,
                      color: whiteColor)),
              onTap: () {
                Get.to(() => ContactUsPage());
              },
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Obx(() {
                return isLoggedIn.value &&
                        profileController.userData['user'] != null
                    ? ListTile(
                        leading: Image.asset(
                          dLogout,
                          height: 24,
                          width: 24,
                        ),
                        title: Text('Logout',
                            style: TextStyle(
                                fontFamily: popinsRegulr,
                                fontSize: 14,
                                color: whiteColor)),
                        onTap: () async {
                          await loginController.logoutUser();
                          Get.to(() => LoginScreen());
                        },
                      )
                    : SizedBox();
              }),
            ),
            SizedBox(
              height: screenHeight * .10,
            )
          ],
        ),
      ),
    );
  }
}
