import 'dart:io';
import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';
import 'package:community_islamic_app/views/family_members/family_members_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/login_controller.dart';
import '../../constants/color.dart';
import '../../constants/image_constants.dart';
import '../../widgets/custome_drawer.dart';
import 'update_password_screen.dart';
import 'personal_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final ProfileController profileController = Get.put(ProfileController());
    print(globals.accessToken.value);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                // Display a loading indicator while data is being fetched
                return SizedBox(
                  height: screenHeight * 0.8, // Height of the screen
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: primaryColor,
                      size: 50.0,
                    ), // Loading indicator
                  ),
                );
              } else if (snapshot.hasError) {
                // If there's an error, display an error message
                return SizedBox(
                  height: screenHeight * 0.8,
                  child: Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                final userData = snapshot.data!['user'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    CircleAvatar(
                      radius: screenWidth *
                          0.16, // Adjust size based on screen width
                      backgroundImage: userData['profile_image'] != null
                          ? NetworkImage(userData['profile_image'])
                          : const AssetImage('assets/images/male.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      " ${userData!['first_name']} ${userData['last_name']}", // Add actual user name here
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.004),
                    Text(
                      userData['email'], // Add actual email here
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 10,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => UpdatePasswordScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColorP,
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
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Card(
                            elevation: 10,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Family Member button press
                                Get.to(() => FamilyMemberScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColorP,
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
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        'Personnel Information',
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      onTap: () {
                        Get.to(() => PersonalInfoScreen());
                      },
                    ),
                    const Divider(),
                    // Uncomment below to add logout button if needed
                    // ListTile(
                    //   leading: const Icon(Icons.person),
                    //   title: Text(
                    //     'Logout',
                    //     style: TextStyle(fontSize: screenWidth * 0.045),
                    //   ),
                    //   onTap: () async {
                    //     await loginController.logoutUser();
                    //     Get.to(() => LoginScreen());
                    //   },
                    // ),
                  ],
                );
              } else {
                return SizedBox(
                  height: screenHeight * 0.8,
                  child: const Center(
                    child: Text(
                      'Please login again',
                      style: TextStyle(fontFamily: popinsMedium),
                    ),
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
