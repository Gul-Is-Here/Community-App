import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/color.dart';
import 'profile_dropdown_widget.dart';
import 'profile_text_widget.dart';

class FamilyMemberCard extends StatefulWidget {
  final String name;
  final String relationship;
  final String dob;
  final int age;
  final String heroTag;
  final String profileImage;
  final void Function() onTap;
  FamilyMemberCard({
    super.key,
    required this.onTap,
    required this.heroTag,
    required this.name,
    required this.relationship,
    required this.dob,
    required this.age,
    required this.profileImage,
  });

  @override
  _FamilyMemberCardState createState() => _FamilyMemberCardState();
}

class _FamilyMemberCardState extends State<FamilyMemberCard> {
  bool isExpanded = false;
  // Controllers for text fields

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(widget.profileImage), // Profile picture
                  ),
                  title: Text(
                    widget.name,
                    style:
                        const TextStyle(fontFamily: popinsBold, fontSize: 13),
                  ),
                  subtitle: Text(
                    '${widget.relationship} - ${widget.dob} - ${widget.age} Years',
                    style:
                        const TextStyle(fontFamily: popinsBold, fontSize: 10),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: whiteColor,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: whiteColor,
                        size: 35,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ),
                ),
                if (isExpanded)
                  Column(
                    children: [
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                'GENERAL INFORMATION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: popinsSemiBold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    'Name ',
                                    style: TextStyle(
                                        fontFamily: popinsRegulr, fontSize: 10),
                                  ),
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                        fontFamily: popinsRegulr, fontSize: 10),
                                  ),
                                  const Text(
                                    'Relation',
                                    style: TextStyle(
                                        fontFamily: popinsRegulr, fontSize: 10),
                                  ),
                                  Text(
                                    widget.relationship,
                                    style: const TextStyle(
                                        fontFamily: popinsRegulr, fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    'DOB',
                                    style: TextStyle(
                                        fontFamily: popinsRegulr, fontSize: 10),
                                  ),
                                  Text(
                                    widget.dob,
                                    style: const TextStyle(
                                        fontFamily: popinsRegulr, fontSize: 10),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Text(
                                      'Age',
                                      style: TextStyle(
                                          fontFamily: popinsRegulr,
                                          fontSize: 10),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 35),
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      widget.age.toString(),
                                      style: const TextStyle(
                                          fontFamily: popinsRegulr,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
                                'AVAILABLE CLASSES',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: popinsSemiBold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Card(
                                    margin: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        // elevation: 5,
                                        // borderRadius: BorderRadius.circular(40),
                                        dropdownColor: Colors.white,
                                        underline:
                                            Container(), // Remove default underline
                                        items: <String>[
                                          'View Details',
                                          'Enrole in Class',
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                  fontFamily: popinsRegulr,
                                                  fontSize: 13),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (_) {},
                                        hint: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            'Class A',
                                            style: TextStyle(
                                                fontFamily: popinsBold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: Stack(
                              children: [
                                // 40.heightBox,
                                Positioned(
                                    left: 20,
                                    bottom: 45,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFFED36A),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5))),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 3),
                                        child: Text(
                                          'waiting for Approval',
                                          style: TextStyle(
                                              fontFamily: popinsSemiBold,
                                              fontSize: 8),
                                        ),
                                      ),
                                    )),
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
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              // elevation: 5,
                                              // borderRadius: BorderRadius.circular(40),
                                              dropdownColor: Colors.white,
                                              underline:
                                                  Container(), // Remove default underline
                                              items: <String>[
                                                'View Details',
                                                'Enrole in Class',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            popinsRegulr,
                                                        fontSize: 13),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (_) {},
                                              hint: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: Text(
                                                  'Class A',
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
                                      // EnrolledClassBadge(
                                      //     'Class B', Colors.green, 'Approved'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Positioned Edit Button, half on and half off the card
          Positioned(
            bottom: -20,
            right: 120,
            child: FloatingActionButton(
              heroTag: widget.heroTag,
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: whiteColor),
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                // Edit action
              },
              mini: true,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.close,
                color: whiteColor,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: 165,
            child: FloatingActionButton(
              heroTag: widget.heroTag,
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: whiteColor),
                  borderRadius: BorderRadius.circular(20)),
              onPressed: widget.onTap,
              mini: true,
              backgroundColor: primaryColor,
              child: Icon(
                Icons.edit,
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
