import 'package:community_islamic_app/controllers/family_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/contact_us/contact_us_screen.dart';
import 'package:community_islamic_app/views/family_members/enrolment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/color.dart';
import 'classdropdown_widget.dart';

class ClassesScreen extends StatelessWidget {
  ClassesScreen({super.key});

  // Controllers
  var familyController = Get.put(FamilyController());
  var profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    // Get relations list from user data
    List<dynamic> relations = profileController.userData['relations'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Classes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor, // Change app bar color to match theme
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Navigate to contact us screen or show information
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsPage()),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        // Observe loading state from the controller
        if (familyController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: relations.length,
          itemBuilder: (context, index) {
            List<dynamic> enrollments =
                relations[index]['hasenrollments'] ?? [];

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.black.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the relation name
                      Text(
                        "${relations[index]['first_name']} ${relations[index]['last_name']}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Available classes section
                      SectionHeader(title: 'CLASSES AVAILABLE'),
                      SizedBox(height: 10),
                      ClassDropdown(
                        classesList: familyController.classesList,
                        member: relations[index],
                      ),

                      SizedBox(height: 16),

                      // Enrolled classes section
                      SectionHeader(title: 'CLASSES ENROLLED'),
                      SizedBox(height: 10),
                      ClassEnrolmentWidget(inrolments: enrollments),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// Section header widget for reusability
class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontFamily: popinsSemiBold,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
