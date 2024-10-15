import 'dart:io';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/infoprofileController.dart';
import 'package:community_islamic_app/views/profile_screen/update_profile_details.dart';
import 'package:community_islamic_app/views/qibla_screen/qibla_screen.dart';
import 'package:community_islamic_app/widgets/custome_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../controllers/profileController.dart';
import '../../widgets/personal_info_row_widget.dart';

class PersonalInfoScreen extends StatelessWidget {
  PersonalInfoScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());
  final Infoprofilecontroller infoprofilecontroller =
      Get.put(Infoprofilecontroller());

  @override
  Widget build(BuildContext context) {
    profileController.fetchUserData();

    Future<void> showAvatarSelectionDialog(String userId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Select an Avatar',
              style: TextStyle(fontFamily: popinsRegulr),
            ),
            content: SizedBox(
              height: 200,
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: infoprofilecontroller.avatar.length,
                itemBuilder: (context, index) {
                  String avatarPath = infoprofilecontroller.avatar[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      infoprofilecontroller.selectAvatar(
                        avatarPath,
                        userId,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Image.asset(avatarPath, width: 100, height: 100),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
              ),
            ),
          );
        },
      );
    }

    Future<void> showImageSourceDialog(String userId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              'Choose Image Source',
              style: TextStyle(fontFamily: popinsBold, fontSize: 18),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  infoprofilecontroller.pickImage(userId);
                },
                child: Row(
                  children: const [
                    Icon(Icons.photo),
                    SizedBox(width: 8),
                    Text(
                      'Gallery',
                      style: TextStyle(fontFamily: popinsRegulr),
                    ),
                  ],
                ),
              ),
              const Divider(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  showAvatarSelectionDialog(userId);
                },
                child: Row(
                  children: const [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text(
                      'Avatars',
                      style: TextStyle(fontFamily: popinsRegulr),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    void _showEditDialog(BuildContext context, Map<String, dynamic> userData) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: UpdateProfileDetails(userData: userData),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      endDrawer: Container(color: Colors.white, child: const CustomDrawer()),
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: profileController.userDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: SpinKitFadingCircle(
              color: primaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data available."));
          } else {
            final userData = snapshot.data!['user'];

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Obx(() {
                              // Update CircleAvatar reactively
                              return CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    infoprofilecontroller.profileImage.value !=
                                            null
                                        ? FileImage(
                                            infoprofilecontroller
                                                .profileImage.value!)
                                        : (userData['profile_image'] !=
                                                        null &&
                                                    userData['profile_image']
                                                        .isNotEmpty
                                                ? NetworkImage(
                                                    userData['profile_image'])
                                                : const AssetImage(
                                                    'assets/images/male.png'))
                                            as ImageProvider,
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  iconSize: 20,
                                  color: Colors.white,
                                  onPressed: () async {
                                    await showImageSourceDialog(
                                        userData['id'].toString());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData['name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: popinsSemiBold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['profession'] ?? 'N/A',
                          style: TextStyle(
                            fontFamily: popinsRegulr,
                            // color:,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    color: containerConlor,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'PERSONAL INFORMATION',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: popinsBold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.heightBox,
                      PersonnelInfoRow(
                          title: 'First Name',
                          value: userData['first_name'] ?? 'N/A'),
                      // const Divider(),
                      PersonnelInfoRow(
                          title: 'Last Name',
                          value: userData['last_name'] ?? 'N/A'),
                      // const Divider(),
                      PersonnelInfoRow(
                          title: 'Email Address',
                          value: userData['email'] ?? 'N/A'),

                      PersonnelInfoRow(
                          title: 'Phone No',
                          value: userData['number'] ?? 'N/A'),

                      PersonnelInfoRow(
                          title: 'DOB', value: userData['dob'] ?? 'N/A'),

                      PersonnelInfoRow(
                          title: 'Residential Address',
                          value: userData['residential_address'] ?? 'N/A'),

                      PersonnelInfoRow(
                          title: 'City', value: userData['city'] ?? 'N/A'),

                      PersonnelInfoRow(
                          title: 'State', value: userData['state'] ?? 'N/A'),

                      PersonnelInfoRow(
                          title: 'Profession',
                          value: userData['profession'] ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, userData);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 10),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(30, 30),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.elliptical(30, 30),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          shadowColor: const Color.fromARGB(255, 171, 212, 234),
                          elevation: 8,
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              color: Colors.white, fontFamily: popinsSemiBold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
