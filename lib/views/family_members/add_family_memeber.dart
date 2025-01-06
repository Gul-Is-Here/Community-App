import 'dart:io';

import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/globals.dart';
import '../../controllers/family_controller.dart';
import '../../controllers/profileController.dart';
import '../../widgets/profile_dropdown_widget.dart';
import '../../widgets/profile_text_widget.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key, required this.member});

  final Map<String, dynamic>? member;

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final FamilyController familyController = Get.put(FamilyController());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String selectedRelation = 'Brother';
  File? _profileImage;

  final List<String> relation = [
    "Father",
    "Husband",
    "Brother",
    "Son",
    "Mother",
    "Wife",
    "Sister",
    "Daughter"
  ];

  bool isLoading = false;

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageSelectionDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Select Profile Picture',
          style: TextStyle(fontFamily: popinsSemiBold, color: Colors.black),
        ),
        content: TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            _pickImageFromGallery();
          },
          icon: Icon(Icons.photo, color: primaryColor),
          label: Text(
            'Select from Gallery',
            style: TextStyle(fontFamily: popinsRegulr, color: primaryColor),
          ),
        ),
      ),
    );
  }

  Future<void> _addFamilyMember() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        dobController.text.isEmpty ||
        selectedRelation.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      await profileController.addFamilyMember(
        id: globals.userId.value,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        relationType: selectedRelation,
        dob: dobController.text,
        profileImage: _profileImage,
      );
      await profileController.fetchUserData2();

      Get.snackbar("Success", "Family Member Added Successfully",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Navigator.of(context).pop();
    } catch (e) {
      Get.snackbar("Error", "Failed to add family member",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
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
          icon: Icon(Icons.arrow_back_ios_new),
          color: whiteColor,
        ),
        title: Text(
          'Add Family Member',
          style: TextStyle(fontFamily: popinsMedium, color: whiteColor),
        ),
        backgroundColor: primaryColor, // Dark green shade for app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF315B5A), // Card green background
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Color(0xFF0E7539)),
                    filled: true,
                    fillColor: lightColor, // Light green shade
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(color: Color(0xFF0E7539)),
                    filled: true,
                    fillColor: lightColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                buildDropdownField(
                  label: "Relationship",
                  value: selectedRelation,
                  items: relation,
                  onChanged: (newValue) {
                    setState(() => selectedRelation = newValue!);
                  },
                ),
                SizedBox(height: 16),
                buildTextField(
                  label: "Date of Birth",
                  controller: dobController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dobController.text =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                if (_profileImage != null)
                  Image.file(_profileImage!, height: 100, width: 100)
                else
                  Text('No image selected.',
                      style: TextStyle(
                          fontFamily: popinsRegulr, color: secondaryColor)),
                TextButton.icon(
                  onPressed: _showImageSelectionDialog,
                  icon: Icon(Icons.photo, color: goldenColor),
                  label: Text('Upload Profile Picture',
                      style: TextStyle(
                          fontFamily: popinsRegulr, color: whiteColor)),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0E8041), // Submit button color
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLoading ? null : _addFamilyMember,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Submit',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
