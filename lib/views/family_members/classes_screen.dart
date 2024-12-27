import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/family_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/family_members/classdropdown_widget.dart';
import 'package:community_islamic_app/views/family_members/buildFamilyMemeberWidget.dart';

import '../../constants/image_constants.dart';

class ClassesScreen extends StatefulWidget {
  ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  // Controllers
  var familyController = Get.put(FamilyController());
  var profileController = Get.find<ProfileController>();

  // Map to track visibility of ClassDropdown for each member
  Map<int, bool> showClassesMap = {};

  @override
  Widget build(BuildContext context) {
    profileController.fetchUserData();
    profileController.fetchUserData2();
    familyController.fetchData();
    profileController.userDataStream;
    // Get relations list from user data
    List<dynamic> relations = profileController.userData['relations'] ?? [];

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white, thickness: 1),
          ),
        ),
        title: Text('Classes',
            style: TextStyle(
                fontSize: 20, fontFamily: popinsRegulr, color: whiteColor)),
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        // Observe loading state from the controller
        if (familyController.isLoading.value) {
          return Center(
            child: SpinKitFadingCircle(color: whiteColor, size: 50.0),
          );
        }

        return ListView.builder(
          itemCount: relations.length,
          itemBuilder: (context, index) {
            List<dynamic> enrollments =
                relations[index]['hasenrollments'] ?? [];
            var enrolCount =
                enrollments.where((e) => e['_active'] == '1').length;

            // Initialize the visibility of ClassDropdown for each member if not already initialized
            if (!showClassesMap.containsKey(index)) {
              showClassesMap[index] = false;
            }

            return Column(
              children: [
                buildFamilyMemberCardClasses(relations[index], enrolCount, () {
                  setState(() {
                    showClassesMap[index] = !showClassesMap[index]!;
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Only show the classes section if the showClassesMap[index] is true
                      if (showClassesMap[index] != null &&
                          showClassesMap[index]!)
                        Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  eventIcon,
                                  height: 24,
                                  width: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    'Classes',
                                    style: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: whiteColor),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              height: 2,
                              color: lightColor,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Show the class dropdown when the icon is clicked
                            ClassDropdown(
                              classesList: familyController.classesList,
                              member: relations[index],
                              inrolments: enrollments,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
