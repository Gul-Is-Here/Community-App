import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../controllers/profileController.dart';
import '../../controllers/updatePasswordController.dart';
import 'package:community_islamic_app/constants/color.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final UpdatePasswordController controller =
      Get.put(UpdatePasswordController());
  final ProfileController profileController = Get.put(ProfileController());

  UpdatePasswordScreen({super.key});

  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    profileController.fetchUserData();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: controller.isLoading.value ? null : () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // StreamBuilder to fetch and display profile image
            StreamBuilder(
              stream: profileController.userDataStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while data is being fetched
                  return SizedBox(
                    height: screenHeight * 0.15, // Height of the screen
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
                  // Extract the profile image URL from the user data
                  final userData = snapshot.data!['user'];
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: screenWidth *
                            0.16, // Adjust size based on screen width
                        backgroundImage: userData['profile_image'] != null
                            ? NetworkImage(userData['profile_image'])
                            : const AssetImage('assets/images/male.png')
                                as ImageProvider,
                      ),
                    ],
                  );
                } else {
                  return const Text('No profile data available');
                }
              },
            ),

            // Display name and profession if available
            StreamBuilder<Map<String, dynamic>>(
              stream: profileController.userDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final String userName =
                      snapshot.data!['user']['name'] ?? 'User';

                  return Column(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  );
                } else {
                  return Container(); // Return an empty container if no data
                }
              },
            ),

            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(color: containerConlor),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Text(
                      'UPDATE PASSWORD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _PasswordTextField(
              label: 'Current Password',
              controller: currentPassController,
            ),
            const SizedBox(height: 20),
            _PasswordTextField(
              label: 'New Password',
              controller: newPassController,
            ),
            const SizedBox(height: 20),
            _PasswordTextField(
              label: 'Confirm Password',
              controller: confirmPassController,
            ),
            const SizedBox(height: 40),
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        String oldPass = currentPassController.text.trim();
                        String newPass = newPassController.text.trim();
                        String confirmPass = confirmPassController.text.trim();

                        // Validation
                        if (oldPass.isEmpty ||
                            newPass.isEmpty ||
                            confirmPass.isEmpty) {
                          Get.snackbar('Error', 'Please fill in all fields');
                          return;
                        }

                        if (newPass.length < 6) {
                          Get.snackbar('Error',
                              'New password must be at least 6 characters');
                          return;
                        }

                        if (newPass != confirmPass) {
                          Get.snackbar('Error', 'Passwords do not match');
                          return;
                        }

                        controller.updatePassword(
                            oldPass, newPass, confirmPass);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(30, 30),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.elliptical(30, 30),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  shadowColor: Colors.tealAccent.shade200,
                  elevation: 10,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'UPDATE PASSWORD',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _PasswordTextField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.white,
        shadowColor: Colors.grey.shade300,
        child: TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}
