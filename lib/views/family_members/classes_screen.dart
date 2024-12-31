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
  final familyController = Get.put(FamilyController());
  final profileController = Get.find<ProfileController>();

  // Map to track visibility of ClassDropdown for each member
  Map<int, bool> showClassesMap = {};

  @override
  void initState() {
    super.initState();
    // Fetch data if necessary
    profileController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    profileController.fetchUserData2();
    profileController.fetchUserData();                                                                                                                                                                                   
    profileController.userDataStream;
    profileController.userData();
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

        // Get relations list from user data
        List<dynamic> relations = profileController.userData['relations'] ?? [];
        if (relations.isEmpty) {
          return Center(
            child: Text(
              'No members available.',
              style: TextStyle(color: whiteColor, fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: relations.length,
          itemBuilder: (context, index) {
            var member = relations[index] ?? {}; // Ensure member is not null
            List<dynamic> enrollments = member['hasenrollments'] ?? [];
            var enrolCount = enrollments
                .where((e) => e != null && e['_active'] == '1')
                .length;

            return Column(
              children: [
                buildFamilyMemberCardClasses(member, enrolCount, () {
                  setState(() {
                    showClassesMap[index] = !(showClassesMap[index] ?? false);
                  });
                  profileController.fetchUserData();
                }),
                if (showClassesMap[index] ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    child: ClassDropdown(
                      // inrolmentStatus: enrollments
                      //     .map((e) => e['_active']?.toString() ?? '')
                      //     .toList(), // Pass all statuses
                      classesList: familyController.classesList,
                      member: member,
                      inrolments: enrollments,
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
