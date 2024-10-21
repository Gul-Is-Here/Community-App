import 'package:community_islamic_app/views/qibla_screen/qibla_screen.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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
    return Column(
      children: widget.classesList.map((classData) {
        // Get the member's age based on their DOB
        int memberAge = AppClass().calculateAge(widget.member['dob']);

        // Ensure minimum_age and maximum_age are parsed as numbers
        int minimumAge = int.tryParse(classData['minimum_age'].toString()) ?? 0;
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
                        _showEnrollDialog(classData);
                      }
                    },

                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          textAlign: TextAlign.left,
                          classData['class_name'], // Display class name as hint
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

// Method to show the disclaimer dialog
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
          content: SingleChildScrollView(
            child: Text(
              description,
              style: TextStyle(
                fontFamily: popinsRegulr,
                fontSize: 14,
                color: Colors.black54,
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

  // Function to show enrollment dialog
  void _showEnrollDialog(dynamic classData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enroll in ${classData['class_name']}'),
          content: const Text('Do you want to enroll in this class?'),
          actions: [
            TextButton(
              child: const Text('Enroll'),
              onPressed: () {
                // Enroll logic here
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
