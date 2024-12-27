import 'package:flutter/material.dart';

import '../../constants/color.dart';

class ClassEnrolmentWidget extends StatelessWidget {
  final List<dynamic> inrolments;
  ClassEnrolmentWidget({super.key, required this.inrolments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .25,
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: inrolments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Enrollment status container at the bottom
                  Positioned(
                    left: 20,
                    bottom: 45,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: () {
                          if (inrolments.isNotEmpty &&
                              index < inrolments.length) {
                            var enrollment = inrolments[index]['_active'];
                            if (enrollment != null && enrollment != null) {
                              String status = enrollment;
                              switch (status) {
                                case '0':
                                  return const Color(
                                      0xFFFED36A); // Waiting for Approval
                                case '1':
                                  return const Color(0xFF1EC7CD); // Approved
                                case '2':
                                  return const Color(0xFFFED36A); // Hold On
                                case '3':
                                  return const Color(0xFFFED36A); // Rejected
                                default:
                                  return Colors.red; // Unknown status
                              }
                            }
                          }
                          return const Color.fromARGB(
                              255, 76, 99, 100); // No enrollments found
                        }(),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 5),
                        child: () {
                          if (inrolments.isNotEmpty &&
                              index < inrolments.length) {
                            String status =
                                inrolments[index]['_active'] ?? 'Unknown';
                            switch (status) {
                              case '0':
                                return const Text('Waiting for Approval',
                                    style: TextStyle(
                                        fontFamily: popinsSemiBold,
                                        fontSize: 8));
                              case '1':
                                return const Text('Approved',
                                    style: TextStyle(
                                        fontFamily: popinsSemiBold,
                                        fontSize: 8));
                              case '2':
                                return const Text('Hold On',
                                    style: TextStyle(
                                        fontFamily: popinsSemiBold,
                                        fontSize: 8));
                              case '3':
                                return const Text('Rejected',
                                    style: TextStyle(
                                        fontFamily: popinsSemiBold,
                                        fontSize: 8));
                              default:
                                return const Text('Unknown',
                                    style: TextStyle(
                                        fontFamily: popinsSemiBold,
                                        fontSize: 8));
                            }
                          } else {
                            return const Text('No Enrollment Found',
                                style: TextStyle(
                                    fontFamily: popinsSemiBold, fontSize: 8));
                          }
                        }(),
                      ),
                    ),
                  ),
                  // Main content with the dropdown
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Card(
                            color: const Color(0xFF1EC7CD),
                            margin: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white,
                                underline:
                                    Container(), // Remove default underline
                                items: inrolments.isNotEmpty &&
                                        index < inrolments.length
                                    ? inrolments[index]
                                                    ['enrollmenthasmanyclasses']
                                                ['available_classes']
                                            ?.map<DropdownMenuItem<String>>(
                                                (classItem) {
                                          return DropdownMenuItem<String>(
                                            value: classItem['class_id'],
                                            child: Text(
                                              classItem['class_name'] ??
                                                  'Unnamed Class',
                                              style: const TextStyle(
                                                  fontFamily: popinsRegulr,
                                                  fontSize: 9),
                                            ),
                                          );
                                        }).toList() ??
                                        []
                                    : [],
                                onChanged: (String? selectedValue) {
                                  // Handle the value selected by the user
                                  print('Selected Class ID: $selectedValue');
                                },
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: inrolments.isNotEmpty &&
                                          index < inrolments.length
                                      ? Text(
                                          inrolments[index][
                                                      'enrollmenthasmanyclasses']
                                                  ['class_name'] ??
                                              'No Class Name',
                                          style: const TextStyle(
                                              fontFamily: popinsBold,
                                              fontSize: 11),
                                        )
                                      : const Text(
                                          'No Enrollment Found',
                                          style: TextStyle(
                                              fontFamily: popinsBold,
                                              fontSize: 13),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
