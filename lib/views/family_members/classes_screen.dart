import 'package:community_islamic_app/views/family_members/enroll_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/controllers/family_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import '../../app_classes/app_class.dart';
import '../../constants/color.dart';
import '../../constants/globals.dart';
import '../../constants/image_constants.dart';

class ClassesScreen extends StatefulWidget {
  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final familyController = Get.put(FamilyController());
  final profileController = Get.find<ProfileController>();
  Map<int, bool> showClassesMap = {};

  @override
  void initState() {
    super.initState();
    profileController.fetchUserData();
    familyController.fetchClasses();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white, thickness: 1),
          ),
        ),
        backgroundColor: primaryColor,
        title: Text(
          'Classes',
          style: TextStyle(
              fontFamily: popinsSemiBold, color: whiteColor, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (familyController.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(
            color: whiteColor,
          ));
        }

        // Get relations (family members) and classes
        List<dynamic> relations = profileController.userData['relations'] ?? [];
        List<dynamic> availableClasses = familyController.classesList;

        if (relations.isEmpty) {
          return const Center(child: Text("No members available."));
        }

        return ListView.builder(
          itemCount: relations.length,
          itemBuilder: (context, index) {
            var member = relations[index];
            List<dynamic> enrollments = member['hasenrollments'] ?? [];
            var enrolCount = enrollments
                .where((e) => e != null && e['_active'] == '1')
                .length;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display family member card
                  Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: screenWidth * .9,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF315B5A), Color(0xFF315B5A)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member['name'],
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontFamily: popinsBold,
                                                fontSize: 16),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(eventIcon,
                                                  height: 24, width: 24),
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
                                              IconButton(
                                                icon: Icon(
                                                  showClassesMap[index] == true
                                                      ? Icons.school_outlined
                                                      : Icons.school,
                                                  color: goldenColor,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    showClassesMap[index] =
                                                        !(showClassesMap[
                                                                index] ??
                                                            false);
                                                  });
                                                },
                                              ),
                                              Text(
                                                enrolCount.toString(),
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontFamily: popinsRegulr),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: screenWidth * .88,
                        child: Container(
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  if (showClassesMap[index] ?? false)
                    Text(
                      'Classes',
                      style: TextStyle(
                          fontFamily: popinsMedium, color: whiteColor),
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  if (showClassesMap[index] ?? false)
                    Divider(
                      color: lightColor,
                    ),
                  if (showClassesMap[index] ?? false)
                    ListView.builder(
                      shrinkWrap:
                          true, // Ensures the ListView takes only the space it needs
                      physics:
                          NeverScrollableScrollPhysics(), // Prevents nested scrolling
                      itemCount: availableClasses.length,
                      itemBuilder: (context, classIndex) {
                        var classData = availableClasses[classIndex];

                        // Calculate age and check eligibility
                        int memberAge = _calculateAge(member['dob']);
                        int minAge = int.parse(classData['minimum_age'] ?? '0');
                        int maxAge =
                            int.parse(classData['maximum_age'] ?? '100');

                        bool ageMatch =
                            memberAge >= minAge && memberAge <= maxAge;
                        bool genderMatch = classData['class_gender'] == "All" ||
                            member['gender'] == classData['class_gender'];

                        // Compare the class_id from availableClasses and enrollments
                        RxString enrollmentStatus = 'Enroll'.obs;
                        // Default to "Enroll"
                        for (var enrollment in enrollments) {
                          int enrollmentClassId =
                              int.tryParse(enrollment['class_id'].toString()) ??
                                  0; // Convert to int
                          int availableClassId =
                              int.tryParse(classData['class_id'].toString()) ??
                                  0;
                          if (enrollmentClassId == availableClassId) {
                            // Match found; get the enrollment status
                            enrollmentStatus.value =
                                _getEnrollmentButtonText(enrollment['_active']);
                            print(
                                'Class: ${classData['class_name']}, Enrollment Status: $enrollmentStatus');

                            break;
                          }
                        }

                        if (ageMatch && genderMatch) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF315B5A),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        classData['class_name'],
                                        style: TextStyle(
                                            fontFamily: popinsMedium,
                                            color: whiteColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Obx(
                                              () => GestureDetector(
                                                onTap: enrollmentStatus.value ==
                                                        'Enroll'
                                                    ? () {
                                                        Get.to(() =>
                                                            EnrollScreen(
                                                                classData:
                                                                    classData,
                                                                member:
                                                                    member));
                                                      }
                                                    : null,
                                                child: Obx(
                                                  () => Container(
                                                    alignment: Alignment.center,
                                                    width: 150,
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: enrollmentStatus
                                                                  .value ==
                                                              'Enroll'
                                                          ? Colors.white
                                                          : enrollmentStatus
                                                                      .value ==
                                                                  'Pending Approval'
                                                              ? goldenColor
                                                              : enrollmentStatus
                                                                          .value ==
                                                                      'Enrolled'
                                                                  ? Colors.green
                                                                  : enrollmentStatus
                                                                              .value ==
                                                                          'Rejected'
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                    ),
                                                    //isable button for other states
                                                    child: Obx(
                                                      () => Text(
                                                        enrollmentStatus.value,
                                                        style: TextStyle(
                                                          color: enrollmentStatus
                                                                      .value ==
                                                                  'Enroll'
                                                              ? Colors.black
                                                              : enrollmentStatus
                                                                          .value ==
                                                                      'Pending Approval'
                                                                  ? whiteColor
                                                                  : enrollmentStatus
                                                                              .value ==
                                                                          'Enrolled'
                                                                      ? const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          170,
                                                                          218,
                                                                          171)
                                                                      : enrollmentStatus.value ==
                                                                              'Rejected'
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .white, // Use white for other states
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                                onPressed: () {
                                                  _showDetailsDialog(classData);
                                                },
                                                child: const Text(
                                                  'Details',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: popinsMedium),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showDetailsDialog(dynamic classData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Text(
              'Class Details',
              style: TextStyle(
                  fontFamily: popinsMedium, fontSize: 18, color: whiteColor),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildDetailRow('Class Fees:', '${classData['class_fees']}'),
                _buildDetailRow(
                    'Class Gender:', '${classData['class_gender']}'),
                _buildDetailRow('Class Start Date:',
                    AppClass().formatDate(classData['start_date'])),
                _buildDetailRow('Class End Date:',
                    AppClass().formatDate(classData['end_date'])),
                _buildDetailRow('Class Start Time:',
                    AppClass().formatTime(classData['start_time'])),
                _buildDetailRow('Class End Time:',
                    AppClass().formatTime(classData['end_time'])),
                _buildDetailRow('Age Group:',
                    '${classData['minimum_age']} - ${classData['maximum_age']}'),
                _buildDetailRow(
                    'Description:', '${classData['class_description']}'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showDisclaimerDialog(
                        context,
                        classData['class_has_disclaimer']['disclaimer_title'],
                        classData['class_has_disclaimer']
                            ['disclaimer_description']);
                  },
                  child: Text(
                    'Disclaimer: Please view carefully.',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
              child: const Text('Close',
                  style: TextStyle(fontFamily: popinsMedium)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisclaimerDialog(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title,
              style: TextStyle(
                  fontFamily: popinsBold, fontSize: 16, color: Colors.black87)),
          content: SizedBox(
            height: 500,
            width: 120,
            child: SingleChildScrollView(
              child: Html(data: description),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
              child: const Text('Close',
                  style: TextStyle(fontFamily: popinsMedium)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int _calculateAge(String dob) {
    try {
      // Ensure the date is formatted as YYYY-MM-DD
      List<String> parts = dob.split('-');
      if (parts.length == 3) {
        // Pad month and day with leading zero if needed
        String formattedDate =
            '${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}';
        DateTime birthDate = DateTime.parse(formattedDate);
        DateTime today = DateTime.now();
        return today.year -
            birthDate.year -
            (today.isBefore(
                    DateTime(today.year, birthDate.month, birthDate.day))
                ? 1
                : 0);
      } else {
        throw FormatException('Invalid date format');
      }
    } catch (e) {
      print('Error parsing date: $dob. Exception: $e');
      return 0; // Return a default age if there's an error
    }
  }

  // Enrollment button text logic
  String _getEnrollmentButtonText(String status) {
    switch (status) {
      case '0':
        return 'Pending Approval';
      case '1':
        return 'Enrolled';
      case '2':
        return 'Hold';
      case '3':
        return 'Rejected';
      default:
        return 'Enroll';
    }
  }
}

// Disclaimer dialog logic
showDisclaimerDialog(BuildContext context, String title, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title,
            style: TextStyle(
                fontFamily: popinsBold, fontSize: 16, color: Colors.black87)),
        content: SizedBox(
          height: 500,
          width: 120,
          child: SingleChildScrollView(
            child: Html(data: description),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            child:
                const Text('Close', style: TextStyle(fontFamily: popinsMedium)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _PasswordTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _PasswordTextField({
    required this.label,
    required this.controller,
    this.validator,
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
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
