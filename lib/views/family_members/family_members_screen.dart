import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/color.dart';
import '../../controllers/profileController.dart';
import '../../widgets/family_card_widget.dart';
import '../../widgets/profile_dropdown_widget.dart';
import '../../widgets/profile_text_widget.dart';
import '../../widgets/project_background.dart';

class FamilyMemberScreen extends StatefulWidget {
  @override
  State<FamilyMemberScreen> createState() => _FamilyMemberScreenState();
}

class _FamilyMemberScreenState extends State<FamilyMemberScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  // Dropdown selections
  String selectedRelation = 'Brother';
  String selectedGender = 'Male';

  // File for profile picture or selected avatar
  File? _profileImage;
  String? _selectedAvatar;

  final List<String> relation = ['Brother', 'Sister', 'Father', 'Mother'];
  final List<String> genders = ["Male", "Female"];
  final List<String> avatars = [
    'assets/images/male.png',
    'assets/images/female.png',
    'assets/images/boy.png',
    'assets/images/girl.png'
  ];

  // Pick image from gallery or camera
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
        _selectedAvatar = null; // Reset avatar selection if image is picked
      }
    });
  }

  // Show dialog to choose between picking avatar or image from gallery
  Future<void> _showImageSelectionDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  showAvatarSelectionDialog();
                },
                icon: Icon(Icons.person),
                label: Text('Select Avatar'),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
                icon: Icon(Icons.photo),
                label: Text('Select from Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show dialog for avatar selection
  Future<void> showAvatarSelectionDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select an Avatar',
            style: TextStyle(fontFamily: popinsRegulr),
          ),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                String avatarPath = avatars[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = avatarPath;
                      _profileImage =
                          null; // Reset profile image if avatar is picked
                    });
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Image.asset(avatarPath, width: 100, height: 100),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Family Member'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTextField(
                        label: "First Name", controller: firstNameController),
                    buildTextField(
                        label: "Last Name", controller: lastNameController),
                    buildDropdownField(
                      label: "Relationship",
                      value: selectedRelation,
                      items: relation,
                      onChanged: (newValue) {
                        setState(() {
                          selectedRelation = newValue!;
                        });
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
                    buildDropdownField(
                        label: "Gender",
                        value: selectedGender,
                        items: genders,
                        onChanged: (newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        }),
                    const SizedBox(height: 10),
                    // Profile Picture or Avatar
                    _profileImage != null
                        ? Image.file(_profileImage!, height: 100, width: 100)
                        : _selectedAvatar != null
                            ? Image.asset(_selectedAvatar!,
                                height: 100, width: 100)
                            : Text('No image or avatar selected.'),
                    TextButton.icon(
                      onPressed: _showImageSelectionDialog,
                      icon: Icon(Icons.photo),
                      label: Text('Upload Profile Picture'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Upload the avatar if selected, otherwise upload the image
                    if (_selectedAvatar != null) {
                      await profileController.addFamilyMember(
                        email: 'gulfarazahmed08@gmail.com',
                        avatar: _selectedAvatar,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        gender: selectedGender,
                        relationType: selectedRelation,
                        dob: dobController.text,
                      );
                    } else if (_profileImage != null) {
                      await profileController.addFamilyMember(
                        email: 'gulfarazahmed08@gmail.com',
                        profileImage: _profileImage,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        gender: selectedGender,
                        relationType: selectedRelation,
                        dob: dobController.text,
                      );
                    }

                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Edit Dialog box
  void _showEditMemberDialog(
      BuildContext context, Map<String, dynamic> member) {
    firstNameController.text = member['first_name'] ?? '';
    lastNameController.text = member['last_name'] ?? '';
    dobController.text = member['dob'] ?? '';
    selectedRelation = member['relation_type'] ?? 'Brother';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Family Member'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTextField(
                        label: "First Name", controller: firstNameController),
                    buildTextField(
                        label: "Last Name", controller: lastNameController),
                    buildDropdownField(
                      label: "Relationship",
                      value: selectedRelation,
                      items: relation,
                      onChanged: (newValue) {
                        setState(() {
                          selectedRelation = newValue!;
                        });
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
                    const SizedBox(height: 10),
                    _profileImage != null
                        ? Image.file(_profileImage!, height: 100, width: 100)
                        : _selectedAvatar != null
                            ? Image.asset(_selectedAvatar!,
                                height: 100, width: 100)
                            : Text('No image or avatar selected.'),
                    TextButton.icon(
                      onPressed: _showImageSelectionDialog,
                      icon: Icon(Icons.photo),
                      label: Text('Upload Profile Picture'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_selectedAvatar != null || _profileImage != null) {
                      await profileController.editFamilyMember(
                        email: 'gulfarazahmed08@gmail.com',
                        id: member['id'].toString(),
                        avatar: _selectedAvatar,
                        profileImage: _profileImage,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        dob: dobController.text,
                        relationType: selectedRelation,
                      );
                    }

                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (profileController.userData.isEmpty) {
          return Center(child: Text("No data available."));
        }

        // Access the relations from userData map
        final List<dynamic> relations =
            profileController.userData['relations'] ?? [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Projectbackground(title: 'Family Members'),
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                width: double.infinity,
                color: primaryColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'FAMILY MEMBERS',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: popinsSemiBold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: relations.length,
                itemBuilder: (context, index) {
                  final member = relations[index];
                  return FamilyMemberCard(
                    heroTag: 'btn$index',
                    name: member['name'] ?? 'Unknown',
                    relationship: member['relation_type'] ?? 'Unknown',
                    dob: member['dob'] ?? 'N/A',
                    age: calculateAge(member['dob']),
                    profileImage:
                        member['profile_image'] ?? 'default_image_path',
                    onTap: () => _showEditMemberDialog(context, member),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  // Utility function to calculate age from date of birth (dob)
  int calculateAge(String dob) {
    if (dob == null || dob.isEmpty) return 0;
    DateTime birthDate = DateTime.tryParse(dob) ?? DateTime.now();
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Widget to build dropdown field
}
