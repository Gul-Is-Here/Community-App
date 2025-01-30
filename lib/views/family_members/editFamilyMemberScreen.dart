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

class EditFamilyMemberScreen extends StatefulWidget {
  final Map<String, dynamic> member;

  const EditFamilyMemberScreen({super.key, required this.member});

  @override
  State<EditFamilyMemberScreen> createState() => _EditFamilyMemberScreenState();
}

class _EditFamilyMemberScreenState extends State<EditFamilyMemberScreen> {
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

  @override
  void initState() {
    super.initState();
    // Set initial values from the passed member data
    firstNameController.text = widget.member['first_name'] ?? '';
    lastNameController.text = widget.member['last_name'] ?? '';
    dobController.text = widget.member['dob'] ?? '';
    selectedRelation = widget.member['relation_type'] ?? 'Brother';
    // If the member has a profile picture URL, load it
    if (widget.member['profile_image'] != null &&
        !widget.member['profile_image'].startsWith('http')) {
      _profileImage = File(widget.member['profile_image']);
    }
  }

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

  Future<void> _editFamilyMember() async {
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
      await profileController.editFamilyMember(
        auth: globals.accessToken.value,
        id: widget.member['id'].toString(),
        roleId: widget.member['role_id'].toString(),
        profileImage: _profileImage,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        dob: dobController.text,
        relationType: selectedRelation,
      );

      Get.snackbar("Success", "Family Member Updated Successfully",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);

      Navigator.of(context).pop();
    } catch (e) {
      Get.snackbar("Error", "Failed to update family member",
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
          'Edit Family Member',
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
                Text(
                  'First Name',
                  style:
                      TextStyle(fontFamily: popinsMedium, color: Colors.green),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: lightColor, // Light green shade
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Last Name',
                  style:
                      TextStyle(fontFamily: popinsMedium, color: Colors.green),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: lightColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Relationship',
                  style:
                      TextStyle(fontFamily: popinsMedium, color: Colors.green),
                ),
                buildDropdownField(
                  label: "",
                  value: selectedRelation,
                  items: relation,
                  onChanged: (newValue) {
                    setState(() => selectedRelation = newValue!);
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Date of Birth',
                  style:
                      TextStyle(fontFamily: popinsMedium, color: Colors.green),
                ),
                SizedBox(
                  height: 5,
                ),
                buildTextField(
                  label: "",
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
                    onPressed: isLoading ? null : _editFamilyMember,
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
