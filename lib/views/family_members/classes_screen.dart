import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/family_controller.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import '../../app_classes/app_class.dart';
import '../../constants/globals.dart';
import 'buildFamilyMemeberWidget.dart';

class ClassesScreen extends StatefulWidget {
  ClassesScreen({super.key});

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
  }

  @override
  Widget build(BuildContext context) {
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
        if (familyController.isLoading.value) {
          return Center(
            child: SpinKitFadingCircle(color: whiteColor, size: 50.0),
          );
        }

        List<dynamic> relations = profileController.userData['relations'] ?? [];
        if (relations.isEmpty) {
          return Center(
            child: Text(
              'No members available.',
              style: TextStyle(
                color: whiteColor,
                fontSize: 18,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: relations.length,
          itemBuilder: (context, index) {
            var member = relations[index] ?? {};
            print(member);
            List<dynamic> enrollent = member['hasenrollments'] ?? [];
            print('Realtions $relations');
            var enrolCount = member['hasenrollments']
                .where((enrollment) => enrollment['_active'] == '1')
                .length;

            print(enrolCount);

            return Column(
              children: [
                buildFamilyMemberCardClasses(member, relations.length, () {
                  setState(() {
                    showClassesMap[index] = !(showClassesMap[index] ?? false);
                  });
                  profileController.fetchUserData();
                }),
                if (showClassesMap[index] ?? false)
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 8.0),
                      child: Column(
                        children: familyController.classesList.map((classData) {
                          int memberAge =
                              AppClass().calculateAge(member['dob']);
                          int minimumAge = int.tryParse(
                                  classData['minimum_age'].toString()) ??
                              0;
                          int maximumAge = int.tryParse(
                                  classData['maximum_age'].toString()) ??
                              100;

                          bool ageMatch = memberAge >= minimumAge &&
                              memberAge <= maximumAge;
                          bool genderMatch =
                              classData['class_gender'] == 'All' ||
                                  member['relation_type'] ==
                                      classData['class_gender'];

                          String enrollmentStatus = getEnrollmentStatus(
                            enrollent,
                          );

                          if (ageMatch && genderMatch) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF315B5A),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 100,
                                child: Card(
                                  color: const Color(0xFF315B5A),
                                  margin: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                classData['class_name'] ?? '',
                                                style: TextStyle(
                                                  fontFamily: popinsBold,
                                                  fontSize: 13,
                                                  color:
                                                      const Color(0xFF00A53C),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: 36,
                                                    width: 110,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: () {
                                                          switch (
                                                              enrollmentStatus) {
                                                            case '':
                                                              return const Color(
                                                                  0xFFFED36A); // Waiting for Approval
                                                            case '1':
                                                              return const Color(
                                                                  0xFF1EC7CD); // Approved
                                                            case '2':
                                                              return const Color(
                                                                  0xFFFED36A); // Hold On
                                                            case '3':
                                                              return const Color(
                                                                  0xFFFED36A); // Rejected
                                                            default:
                                                              return const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  76,
                                                                  99,
                                                                  100); // No enrollment
                                                          }
                                                        }(),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        print(
                                                            'enrollmentStatus  :  $enrollmentStatus');
                                                        if (enrollmentStatus ==
                                                            '') {
                                                          showEnrollDialog(
                                                              classData,
                                                              familyController,
                                                              member);
                                                        } else {
                                                          print(
                                                              'Already Enrolled or Waiting for Approval');
                                                        }
                                                      },
                                                      child: Text(
                                                        enrollmentStatus == ''
                                                            ? 'Enroll'
                                                            : _getEnrollButtonText(
                                                                enrollmentStatus),
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              popinsSemiBold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  SizedBox(
                                                    height: 36,
                                                    width: 110,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            whiteColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _showDetailsDialog(
                                                            classData);
                                                      },
                                                      child: const Text(
                                                        'Details',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              popinsRegulr,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }).toList(),
                      )),
              ],
            );
          },
        );
      }),
    );
  }

  String getEnrollmentStatus(
    List<dynamic> enrollments,
  ) {
    // Loop through enrollments to find the matching class ID
    for (var enrollment in enrollments) {
      switch (enrollment['_active']) {
        case '0':
          return '0'; // Waiting for Approval
        case '1':
          return '1'; // Approved
        case '2':
          return '2'; // Hold On
        case '3':
          return '3'; // Rejected
        default:
          return ''; // No matching status
      }
    }
    return ''; // No enrollment found for this class
  }

  String _getEnrollButtonText(String status) {
    switch (status) {
      case '0':
        return 'Waiting for Approval';
      case '1':
        return 'Approved';
      case '2':
        return 'Hold On';
      case '3':
        return 'Rejected';
      default:
        return 'Enroll';
    }
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

  void showEnrollDialog(
      dynamic classData, FamilyController familyController, dynamic member) {
    bool isAllergic = false;
    bool isAcknowledged = false;
    bool isLoading = false;
    TextEditingController allergiesController = TextEditingController();
    TextEditingController emergencyContactController = TextEditingController();
    TextEditingController emergencyContactNameController =
        TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: primaryColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ENROLLMENT FORM',
                      style:
                          TextStyle(fontFamily: popinsBold, color: whiteColor),
                    ),
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      _PasswordTextField(
                        label: 'Emergency Contact',
                        controller: emergencyContactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter emergency contact';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _PasswordTextField(
                        label: 'Emergency Contact Name',
                        controller: emergencyContactNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter emergency contact name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 5,
                        color: whiteColor,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            label: Text(
                              'Allergic',
                              style: TextStyle(
                                  fontFamily: popinsSemiBold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'YES', child: Text('YES')),
                            DropdownMenuItem(value: 'NO', child: Text('NO')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              isAllergic = value == 'YES';
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isAllergic)
                        _PasswordTextField(
                          label: 'Allergic Details',
                          controller: allergiesController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide allergic details';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _showDisclaimerDialog(
                              context,
                              classData['class_has_disclaimer']
                                  ['disclaimer_title'],
                              classData['class_has_disclaimer']
                                  ['disclaimer_description']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Disclaimer: Please view carefully.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: primaryColor,
                            value: isAcknowledged,
                            onChanged: (value) {
                              setState(() {
                                isAcknowledged = value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'I Acknowledge That I Have Read, Understood And Agreed To The Rosenberg Community Center Policies And Procedures',
                              style: TextStyle(
                                  fontSize: 12, fontFamily: popinsRegulr),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: isLoading
                      ? SpinKitFadingCircle(color: primaryColor)
                      : ElevatedButton(
                          onPressed: isAcknowledged
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    try {
                                      await familyController.registerForClass(
                                        context: context,
                                        token: globals.accessToken.value,
                                        classId: classData['class_id'],
                                        id: member['id'],
                                        relationId: member['relation_id'],
                                        emergencyContact:
                                            emergencyContactController.text,
                                        emergencyContactName:
                                            emergencyContactNameController.text,
                                        allergiesDetail:
                                            allergiesController.text,
                                      );
                                      Navigator.of(context).pop();
                                    } catch (error) {
                                      print("Error: $error");
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                        ProfileController().fetchUserData2();
                                      });
                                    }
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(30, 30),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.elliptical(30, 30),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            shadowColor:
                                const Color.fromARGB(255, 252, 254, 255),
                            elevation: 8,
                          ),
                          child: Text(
                            'ENROLL IN CLASS',
                            style: TextStyle(
                                fontFamily: popinsSemiBold, color: whiteColor),
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
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
