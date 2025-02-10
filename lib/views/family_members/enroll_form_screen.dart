import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:community_islamic_app/views/family_members/class_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/controllers/family_controller.dart';
import '../../constants/color.dart';
import '../../constants/globals.dart';

class EnrollScreen extends StatefulWidget {
  final dynamic classData;
  final dynamic member;

  const EnrollScreen({required this.classData, required this.member, Key? key})
      : super(key: key);

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  final familyController = Get.put(FamilyController());
  final _formKey = GlobalKey<FormState>();

  TextEditingController allergiesController = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();
  TextEditingController emergencyContactNameController =
      TextEditingController();

  bool isAllergic = false;
  bool isAcknowledged = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002B36),
      appBar: AppBar(
        title: Text(
          'Enrollment Form',
          style: TextStyle(color: whiteColor, fontFamily: popinsMedium),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white, thickness: 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                title: 'Emergency Contact',
                label: 'Emergency Contact',
                controller: emergencyContactController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter emergency contact';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                title: 'Emergency Contact Name',
                label: 'Emergency Contact Name',
                controller: emergencyContactNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter emergency contact name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                title: 'Allergic',
                label: 'Allergic',
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
              if (isAllergic)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildTextField2(
                      title: 'Allergic Details',
                      label: 'Allergy Details',
                      controller: allergiesController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide allergy details';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showDisclaimerDialog(
                  context,
                  widget.classData['class_has_disclaimer']['disclaimer_title'],
                  widget.classData['class_has_disclaimer']
                      ['disclaimer_description'],
                ),
                child: const Text(
                  'Disclaimer',
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: popinsRegulr,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: whiteColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    onPressed: () {
                      Get.to(
                        () => ClassDetailsScreen(
                          classId: widget.classData['class_id'],
                          className: widget.classData['class_name'],
                          startTime: (widget.classData['start_time']),
                          endTime: (widget.classData['end_time']),
                          gender: widget.classData['class_gender'],
                          classFees: widget.classData['class_fees'],
                          startDate: AppClass()
                              .formatDate(widget.classData['start_date']),
                          endDate: AppClass()
                              .formatDate(widget.classData['end_date']),
                          ageGroup:
                              "${widget.classData['minimum_age']} - ${widget.classData['maximum_age']}",
                          details: widget.classData!['class_description'],
                          disclaimer: widget.classData['class_has_disclaimer']
                              ['disclaimer_description'],
                        ),
                      );
                    },
                    child: const Text(
                      'View',
                      style: TextStyle(
                        fontFamily: popinsRegulr,
                        color: Colors.black,
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    hoverColor: whiteColor,
                    checkColor: primaryColor,
                    activeColor: lightColor,
                    value: isAcknowledged,
                    onChanged: (value) {
                      setState(() {
                        isAcknowledged = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I Acknowledge That I Have Read, Understood, And Agreed To The Rosenberg Community Center Policies And Procedures',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: popinsRegulr,
                          color: whiteColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                                      userId: widget.member['id'],
                                      context: context,
                                      token: globals.accessToken.value,
                                      classId: widget.classData['class_id'],
                                      relationId: widget.member['relation_id'],
                                      emergencyContact:
                                          emergencyContactController.text,
                                      emergencyContactName:
                                          emergencyContactNameController.text,
                                      allergiesDetail: allergiesController.text,
                                    );
                                    await ProfileController().fetchUserData2();
                                    await ProfileController().fetchUserData();
                                    Navigator.of(context).pop();
                                  } catch (error) {
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
                          // shadowColor: whiteColor,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Enroll',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontFamily: popinsRegulr, color: Colors.green),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 1,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(fontFamily: popinsRegulr),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: lightColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField2({
    required String title,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontFamily: popinsRegulr, color: Colors.green),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 4,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(fontFamily: popinsRegulr),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: lightColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String title,
    required String label,
    required List<DropdownMenuItem<String>> items,
    void Function(String?)? onChanged,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 10,
      children: [
        Text(
          title,
          style: TextStyle(fontFamily: popinsRegulr, color: Colors.green),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.greenAccent.shade100,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black)),
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
                  style: TextStyle(fontWeight: FontWeight.w500)),
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
