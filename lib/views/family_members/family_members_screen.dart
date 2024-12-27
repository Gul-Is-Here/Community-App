import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/family_members/add_family_memeber.dart';
import 'package:community_islamic_app/views/family_members/editFamilyMemberScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../app_classes/app_class.dart';
import '../../constants/color.dart';
import '../../controllers/profileController.dart';
import '../../controllers/family_controller.dart';

class FamilyMemberScreen extends StatefulWidget {
  @override
  State<FamilyMemberScreen> createState() => _FamilyMemberScreenState();
}

class _FamilyMemberScreenState extends State<FamilyMemberScreen> {
  late var member;
  final ProfileController profileController = Get.put(ProfileController());
  final FamilyController familyController = Get.put(FamilyController());

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    profileController.userData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Family Members',
          style: TextStyle(
              fontFamily: popinsMedium, fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white, thickness: 1),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(width: 2, color: goldenColor),
        ),
        onPressed: () {
          Get.to(() => AddFamilyMemberScreen(
                member: member,
              ));
        },
        child: Icon(Icons.add, size: 30, color: whiteColor),
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(
            child: SpinKitFadingCircle(color: whiteColor, size: 50.0),
          );
        }

        if (profileController.userData.isEmpty) {
          return Center(
            child: Text("No data available.",
                style: TextStyle(color: whiteColor, fontFamily: popinsRegulr)),
          );
        }

        List<dynamic> relations = profileController.userData['relations'] ?? [];
        return ListView.builder(
          itemCount: relations.length,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemBuilder: (context, index) {
            member = relations[index];
            return buildFamilyMemberCard(member);
          },
        );
      }),
    );
  }

  Widget buildFamilyMemberCard(Map<String, dynamic> member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: whiteColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00A559), Color(0xFF006627)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member['name'],
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: popinsBold,
                                fontSize: 16),
                          ),
                          Row(
                            children: [
                              Image.asset(eventIcon, height: 24, width: 24),
                              const SizedBox(width: 8),
                              Text(
                                '${AppClass().formatDate(member['dob'])} (${AppClass().calculateAge(member['dob'])} Years) - ',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: popinsBold,
                                    fontSize: 12),
                              ),
                              Text(
                                member['relation_type'],
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: popinsBold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: 8,
                  decoration: BoxDecoration(
                    color: goldenColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -20,
            right: 120,
            child: _buildActionButton(
              icon: Icons.refresh,
              color: asColor,
              onPressed: () {
                profileController.fetchUserData2();
              },
            ),
          ),
          Positioned(
            bottom: -20,
            right: 165,
            child: _buildActionButton(
              icon: Icons.edit,
              color: primaryColor,
              onPressed: () {
                Get.to(() => EditFamilyMemberScreen(member: member));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(width: 2, color: goldenColor),
      ),
      onPressed: onPressed,
      child: Icon(icon, color: whiteColor),
    );
  }
}
