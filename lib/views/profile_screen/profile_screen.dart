import 'dart:io';
import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';
import 'package:community_islamic_app/views/family_members/classes_screen.dart';
import 'package:community_islamic_app/views/family_members/family_members_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../constants/color.dart';
import '../../widgets/custome_drawer.dart';
import 'update_password_screen.dart';
import 'personal_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    profileController.fetchUserData();
    profileController.fetchUserData2();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      // drawerScrimColor: whiteColor,

      // endDrawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: StreamBuilder(
            stream: profileController.userDataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: screenHeight * 0.8,
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: lightColor,
                      size: 50.0,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return SizedBox(
                  height: screenHeight * 0.8,
                  child: Center(
                    child: Text(
                      'Session Expire Please Login again',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                final userData = snapshot.data?['user'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    CircleAvatar(
                      radius: screenWidth * 0.16,
                      backgroundImage: userData?['profile_image'] != null
                          ? NetworkImage(userData['profile_image'])
                          : const AssetImage('assets/images/male.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "${userData?['first_name'] ?? ''} ${userData?['last_name'] ?? ''}",
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontFamily: popinsMedium,
                          color: whiteColor),
                    ),
                    SizedBox(height: screenHeight * 0.004),
                    Text(
                      userData?['email'] ?? '',
                      style: TextStyle(
                        fontFamily: popinsMedium,
                        fontSize: screenWidth * 0.045,
                        color: whiteColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                      colors: [Colors.green, primaryColor])),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => UpdatePasswordScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.025,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Update Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Card(
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                      colors: [Colors.green, primaryColor])),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => FamilyMemberScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                    vertical: screenHeight * 0.025,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Family Member',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Divider(
                      color: lightColor,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: whiteColor,
                      ),
                      title: Text(
                        'Personal Information',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontFamily: popinsRegulr,
                            color: whiteColor),
                      ),
                      onTap: () {
                        Get.to(() => PersonalInfoScreen());
                      },
                    ),
                    Divider(
                      color: lightColor,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.group,
                        color: whiteColor,
                      ),
                      title: Text(
                        'Family Members',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontFamily: popinsRegulr,
                            color: whiteColor),
                      ),
                      onTap: () {
                        Get.to(() => FamilyMemberScreen());
                      },
                    ),
                    Divider(
                      color: lightColor,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.class_sharp,
                        color: whiteColor,
                      ),
                      title: Text(
                        'Classes',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontFamily: popinsRegulr,
                            color: whiteColor),
                      ),
                      onTap: () {
                        Get.to(() => ClassesScreen());
                      },
                    ),
                    Divider(
                      color: lightColor,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: whiteColor,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontFamily: popinsRegulr,
                            color: whiteColor),
                      ),
                      onTap: () async {
                        await loginController.logoutUser();
                        Get.offAll(() => LoginScreen());
                      },
                    ),
                  ],
                );
              } else {
                return SizedBox(
                  height: screenHeight * 0.8,
                  child: const Center(
                    child: Text("No data available."),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
