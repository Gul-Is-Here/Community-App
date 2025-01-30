import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ClassDetailsScreen extends StatelessWidget {
  final int classId;
  final String className;
  final String startTime;
  final String endTime;
  final String gender;
  final String classFees;
  final String startDate;
  final String endDate;
  final String ageGroup;
  final String details;
  final String disclaimer;

  ClassDetailsScreen(
      {required this.classId,
      required this.className,
      required this.startTime,
      required this.endTime,
      required this.gender,
      required this.classFees,
      required this.startDate,
      required this.endDate,
      required this.ageGroup,
      required this.details,
      required this.disclaimer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Class Details',
          style: TextStyle(fontFamily: 'PopinsMedium', color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                className,
                style: TextStyle(
                    fontFamily: 'PopinsBold',
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class Time',
                        style: TextStyle(
                            fontFamily: 'PopinsMedium',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Start: $startTime\nEnd: $endTime',
                        style: TextStyle(
                            fontFamily: 'PopinsRegular', fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class',
                        style: TextStyle(
                            fontFamily: 'PopinsMedium',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Gender: $gender\nClass Fees: $classFees',
                        style: TextStyle(
                            fontFamily: 'PopinsRegular', fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Class Start Date',
                style: TextStyle(
                    fontFamily: 'PopinsMedium',
                    fontSize: 14,
                    color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                startDate,
                style: TextStyle(fontFamily: 'PopinsRegular', fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                'Class End Date',
                style: TextStyle(
                    fontFamily: 'PopinsMedium',
                    fontSize: 14,
                    color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                endDate,
                style: TextStyle(fontFamily: 'PopinsRegular', fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                'Age Group',
                style: TextStyle(
                    fontFamily: 'PopinsMedium',
                    fontSize: 14,
                    color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                ageGroup,
                style: TextStyle(fontFamily: 'PopinsRegular', fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                'Details',
                style: TextStyle(
                    fontFamily: 'PopinsMedium',
                    fontSize: 14,
                    color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                details,
                style: TextStyle(fontFamily: 'PopinsRegular', fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                'Disclaimer',
                style: TextStyle(
                    fontFamily: 'PopinsMedium',
                    fontSize: 14,
                    color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Html(data: disclaimer)
            ],
          ),
        ),
      ),
    );
  }
}
