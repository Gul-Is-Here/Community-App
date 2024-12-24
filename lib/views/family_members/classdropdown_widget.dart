import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/controllers/family_controller.dart';
import 'package:community_islamic_app/views/family_members/add_enrolment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../app_classes/app_class.dart';
import '../../constants/color.dart';

class ClassDropdown extends StatefulWidget {
  final List<dynamic> classesList;
  final Map<String, dynamic> member;

  const ClassDropdown({
    required this.classesList,
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _ClassDropdownState createState() => _ClassDropdownState();
}

class _ClassDropdownState extends State<ClassDropdown> {
  // Track selected class for each dropdown (optional, for future use)
  String? selectedClass;

  @override
  Widget build(BuildContext context) {
    FamilyController familyController = Get.put(FamilyController());

    return Obx(() {
      // Show a loading indicator while data is being fetched
      if (familyController.isLoading.value) {
        return Center(child: SpinKitFadingCircle(color: primaryColor));
      }

      // If there are no classes available, show a message
      if (widget.classesList.isEmpty) {
        return Center(child: Text('No classes available.'));
      }

      return Column(
        children: widget.classesList.map((classData) {
          // Get the member's age based on their DOB
          int memberAge = AppClass().calculateAge(widget.member['dob']);

          // Ensure minimum_age and maximum_age are parsed as numbers
          int minimumAge =
              int.tryParse(classData['minimum_age'].toString()) ?? 0;
          int maximumAge =
              int.tryParse(classData['maximum_age'].toString()) ?? 100;

          // Check age condition
          bool ageMatch = memberAge >= minimumAge && memberAge <= maximumAge;

          // Check gender condition (if class_gender is "All", allow any gender)
          bool genderMatch = classData['class_gender'] == 'All' ||
              widget.member['relation_type'] == classData['class_gender'];

          // Only show dropdown if both conditions are met
          if (ageMatch && genderMatch) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                color: whiteColor,
                height: 30,
                child: Card(
                  color: whiteColor,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      underline: Container(
                        color: whiteColor,
                      ), // Remove default underline

                      // Items for dropdown (View Details and Enroll in Class)
                      items: <String>['View Details', 'Enroll in Class']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            textAlign: TextAlign.left,
                            value,
                            style: const TextStyle(
                              fontFamily: popinsRegulr,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),

                      // Handle the selected dropdown item
                      onChanged: (String? selectedOption) {
                        if (selectedOption == 'View Details') {
                          // Show details dialog
                          _showDetailsDialog(classData);
                        } else if (selectedOption == 'Enroll in Class') {
                          // Show enrollment dialog or process
                          _showEnrollDialog(
                              classData, familyController, widget.member);
                        }
                      },

                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            textAlign: TextAlign.left,
                            classData[
                                'class_name'], // Display class name as hint
                            style: const TextStyle(
                              fontFamily: popinsBold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            // If the class doesn't match the criteria, don't display anything.
            return Container();
          }
        }).toList(),
      );
    });
  }

  void _showDetailsDialog(dynamic classData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Background color of the dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
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
                fontFamily: popinsMedium,
                fontSize: 18,
                color: whiteColor,
              ),
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
                const SizedBox(height: 10), // Add spacing
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
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Button text color
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontFamily: popinsMedium),
              ),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black54,
              ),
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
          backgroundColor: Colors.white, // Background color of the dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: popinsBold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          content: SizedBox(
            height: 500,
            width: 120,
            child: SingleChildScrollView(
              child: Html(
                data: description,
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Button text color
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontFamily: popinsMedium),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEnrollDialog(
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
                  // Wrap with Form widget
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
                        PasswordTextField(
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
                                      // Handle the error
                                      print("Error: $error");
                                    } finally {
                                      setState(() {
                                        isLoading = false;
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
  final String? Function(String?)? validator; // Added validator

  const _PasswordTextField({
    required this.label,
    required this.controller,
    this.validator, // Pass the validator
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
          validator: validator, // Apply validator
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator; // Added validator

  const PasswordTextField({
    required this.label,
    required this.controller,
    this.validator, // Pass the validator
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: Colors.white,
      shadowColor: Colors.grey.shade300,
      child: TextFormField(
        maxLines: 3,
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
        validator: validator, // Apply validator
      ),
    );
  }
}
