import 'package:community_islamic_app/controllers/family_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/contact_us/contact_us_screen.dart';
import 'package:community_islamic_app/views/family_members/enrolment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/color.dart';
import 'classdropdown_widget.dart';

class ClassesScreen extends StatelessWidget {
  ClassesScreen({super.key});
  var familyController = Get.put(FamilyController());
  var profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    List<dynamic> relations = profileController.userData['relations'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: ListView.builder(
          itemCount: relations.length,
          itemBuilder: (context, index) {
            List<dynamic> inrolments = relations[index]['hasenrollments'] ?? [];
            return Column(
              children: [
                Text(
                    "${relations[index]['first_name']} ${relations[index]['last_name']}"),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 28,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'CLASSES AVAILABLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: popinsSemiBold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                5.heightBox,
                ClassDropdown(
                    classesList: familyController.classesList,
                    member: relations[index]),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 28,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'CLASSES ENROLLED',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: popinsSemiBold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ClassEnrolmentWidget(inrolments: inrolments)
              ],
            );
          }),
    );
  }
}
