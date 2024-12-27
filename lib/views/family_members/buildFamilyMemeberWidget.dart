import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_classes/app_class.dart';
import '../../constants/color.dart';
import '../../constants/image_constants.dart';
import 'editFamilyMemberScreen.dart';

Widget buildFamilyMemberCardClasses(Map<String, dynamic> member, int count,  Function() onTap) {
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
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: onTap,
                                icon: Icon(
                                  Icons.school,
                                  color: goldenColor,
                                )),
                            Text(
                              count.toString(),
                              style: TextStyle(color: whiteColor, fontFamily: popinsRegulr),
                            )
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
        // Positioned(
        //   bottom: -20,
        //   right: 120,
        //   child: _buildActionButton(
        //     icon: Icons.refresh,
        //     color: asColor,
        //     onPressed: () {
        //       profileController.fetchUserData2();
        //     },
        //   ),
        // ),
        // Positioned(
        //   bottom: -20,
        //   right: 165,
        //   child: _buildActionButton(
        //     icon: Icons.edit,
        //     color: primaryColor,
        //     onPressed: () {
        //       Get.to(() => EditFamilyMemberScreen(member: member));
        //     },
        //   ),
        // ),
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
