import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/color.dart';
import '../../widgets/profile_dropdown_widget.dart';
import '../../widgets/profile_text_widget.dart';

class MemberFormScreen extends StatelessWidget {
  final String title;
  final Map<String, dynamic>? member;
  final VoidCallback onSave;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;
  String selectedRelation;
  final List<String> relation;
  final File? profileImage;
  final ValueChanged<File?> onImageSelected;

  MemberFormScreen({
    required this.title,
    required this.onSave,
    this.member,
    required this.firstNameController,
    required this.lastNameController,
    required this.dobController,
    required this.selectedRelation,
    required this.relation,
    required this.profileImage,
    required this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(
                label: "First Name", controller: firstNameController),
            buildTextField(label: "Last Name", controller: lastNameController),
            buildDropdownField(
              label: "Relationship",
              value: selectedRelation,
              items: relation,
              onChanged: (newValue) {
                selectedRelation = newValue!;
              },
            ),
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
                  dobController.text =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                }
              },
            ),
            if (profileImage != null)
              Image.file(profileImage!, height: 100, width: 100)
            else
              const Text('No image selected.'),
            TextButton.icon(
              onPressed: () => _pickImage(context),
              icon: Icon(Icons.photo, color: primaryColor),
              label: Text('Upload Profile Picture',
                  style: TextStyle(color: primaryColor)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
