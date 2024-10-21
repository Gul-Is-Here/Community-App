import 'dart:io';
import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/controllers/family_controller.dart';
import 'package:community_islamic_app/views/family_members/classdropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final FamilyController familyController = Get.put(FamilyController());

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  String selectedRelation = 'Brother';
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    List<dynamic> relations = profileController.userData['relations'] ?? [];
    isExpandedList = List.generate(relations.length, (index) => false);
  }

  File? _profileImage;
  // bool isExpanded = false; // Individual state for each widget
  bool isLoading = false; // Loading state

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

  final List<String> avatars = [
    'assets/images/male.png',
    'assets/images/female.png',
    'assets/images/boy.png',
    'assets/images/girl.png'
  ];

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
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select Profile Picture',
            style: TextStyle(fontFamily: popinsSemiBold, color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
                icon: Icon(
                  Icons.photo,
                  color: primaryColor,
                ),
                label: Text(
                  'Select from Gallery',
                  style:
                      TextStyle(fontFamily: popinsRegulr, color: primaryColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient:
              const LinearGradient(colors: [gradianColor1, gradianColor2]),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(width: 2, color: whiteColor),
          ),
          onPressed: () {
            showAddMemberDialog(context);
            lastNameController.clear();
            firstNameController.clear();
            dobController.clear();
          },
          child: Icon(
            Icons.add,
            size: 30,
            color: whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Projectbackground(title: 'Family Members'),
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              width: double.infinity,
              color: primaryColor,
              child: const Padding(
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
            Obx(() {
              if (profileController.isLoading.value) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: primaryColor,
                    size: 50.0,
                  ),
                ); // Loading indicator
              }

              if (profileController.userData.isEmpty) {
                return const Center(
                    child: Text(
                  "No data available.",
                  style:
                      TextStyle(color: Colors.black, fontFamily: popinsRegulr),
                ));
              }
              List<dynamic> relations =
                  profileController.userData['relations'] ?? [];
              return ListView.builder(
                shrinkWrap: true, padding: const EdgeInsets.all(0),
                physics:
                    const NeverScrollableScrollPhysics(), // Disable internal scrolling
                itemCount: relations.length,
                itemBuilder: (context, index) {
                  final member = relations[index];

                  if (member == null) {
                    isExpandedList =
                        List.generate(member.lenght, (index) => false);
                    return const Center(
                      child: Text(
                        'No Family Member Added Yet',
                        style: TextStyle(fontFamily: popinsRegulr),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: FamilyMemberCard(
                      //   heroTag: 'btn$index',
                      //   name: member['name'] ?? 'Unknown',
                      //   relationship: member['relation_type'] ?? 'Unknown',
                      //   dob: member['dob'] ?? 'N/A',
                      //   age: AppClass().calculateAge(member['dob']),
                      //   profileImage:
                      //       member['profile_image'] ?? 'default_image_path',
                      //   onTap: () => _showEditMemberDialog(context, member),
                      // ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Card(
                            color: whiteColor,
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
                                    backgroundImage: NetworkImage(member[
                                            'profile_image'] ??
                                        'default_image_path'), // Profile picture
                                  ),
                                  title: Text(
                                    member['name'],
                                    style: const TextStyle(
                                        fontFamily: popinsBold, fontSize: 13),
                                  ),
                                  subtitle: Text(
                                    '${member['relation_type'] ?? 'Unknown'} - ${member['dob'] ?? 'N/A'} - ${AppClass().calculateAge(member['dob'])} Years',
                                    style: const TextStyle(
                                        fontFamily: popinsBold, fontSize: 10),
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
                                        isExpandedList[index]
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: whiteColor,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isExpandedList[index] =
                                              !isExpandedList[index];
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                if (isExpandedList[index]) ...[
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 28,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'Name ',
                                                style: TextStyle(
                                                    fontFamily: popinsRegulr,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                member['name'],
                                                style: const TextStyle(
                                                    fontFamily: popinsRegulr,
                                                    fontSize: 10),
                                              ),
                                              const Text(
                                                'Relation',
                                                style: TextStyle(
                                                    fontFamily: popinsRegulr,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                member['relation_type'],
                                                style: const TextStyle(
                                                    fontFamily: popinsRegulr,
                                                    fontSize: 10),
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
                                                    fontFamily: popinsRegulr,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                member['dob'],
                                                style: const TextStyle(
                                                    fontFamily: popinsRegulr,
                                                    fontSize: 10),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text(
                                                  'Age',
                                                  style: TextStyle(
                                                      fontFamily: popinsRegulr,
                                                      fontSize: 10),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0),
                                                child: Text(
                                                  textAlign: TextAlign.start,
                                                  AppClass()
                                                      .calculateAge(
                                                          member['dob'])
                                                      .toString(),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClassDropdown(
                                                classesList: familyController
                                                    .classesList,
                                                member: member)
//
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xFFFED36A),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              topRight: Radius
                                                                  .circular(
                                                                      5))),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                    child: Text(
                                                      'waiting for Approval',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              popinsSemiBold,
                                                          fontSize: 8),
                                                    ),
                                                  ),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    child: Card(
                                                      color: const Color(
                                                          0xFF1EC7CD),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      child: Center(
                                                        child: DropdownButton<
                                                            String>(
                                                          // elevation: 5,
                                                          // borderRadius: BorderRadius.circular(40),
                                                          dropdownColor:
                                                              Colors.white,
                                                          underline:
                                                              Container(), // Remove default underline
                                                          items: <String>[
                                                            'View Details',
                                                            'Enrole in Class',
                                                          ].map((String value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        popinsRegulr,
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (_) {},
                                                          hint: const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            child: Text(
                                                              'Class A',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      popinsBold,
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
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Positioned Edit Button, half on and half off the card
                          Positioned(
                            bottom: -20,
                            right: 120,
                            child: FloatingActionButton(
                              heroTag: 'btn+$index',
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
                              heroTag: 'btn+$index',
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 2, color: whiteColor),
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                _showEditMemberDialog(context, member);
                              },
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
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Add Family Member',
                style: TextStyle(fontFamily: popinsSemiBold),
              ),
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
                        if (mounted) {
                          setState(() {
                            selectedRelation = newValue!;
                          });
                        }
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
                          if (mounted) {
                            setState(() {
                              dobController.text =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            });
                          }
                        }
                      },
                    ),
                    _profileImage != null
                        ? Image.file(_profileImage!, height: 100, width: 100)
                        : const Text(
                            'No image selected.',
                            style: TextStyle(fontFamily: popinsRegulr),
                          ),
                    TextButton.icon(
                      onPressed: _showImageSelectionDialog,
                      icon: Icon(Icons.photo, color: primaryColor),
                      label: Text(
                        'Upload Profile Picture',
                        style: TextStyle(
                            fontFamily: popinsRegulr, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: popinsSemiBold, color: primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Start loading
                    });
                    await profileController.addFamilyMember(
                      id: globals.userId.value,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      relationType: selectedRelation,
                      dob: dobController.text,
                      profileImage: _profileImage,
                    );

                    // Clear form fields
                    firstNameController.clear();
                    lastNameController.clear();
                    dobController.clear();
                    _profileImage = null;

                    // Fetch updated list of family members
                    await profileController.fetchUserData2();

                    setState(() {
                      isLoading = false; // Stop loading
                    });

                    Navigator.of(context).pop();
                  },
                  child: isLoading
                      ? SpinKitFadingCircle(
                          color: primaryColor,
                          size: 50.0,
                        ) // Loading indicator
                      : Text(
                          'Save',
                          style: TextStyle(
                              fontFamily: popinsSemiBold, color: primaryColor),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
              title: const Text(
                'Edit Family Member',
                style: TextStyle(fontFamily: popinsSemiBold),
              ),
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
                        if (mounted) {
                          setState(() {
                            selectedRelation = newValue!;
                          });
                        }
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
                          if (mounted) {
                            setState(() {
                              dobController.text =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            });
                          }
                        }
                      },
                    ),
                    _profileImage != null
                        ? Image.file(_profileImage!, height: 100, width: 100)
                        : const Text(
                            'No image selected.',
                            style: TextStyle(
                                fontFamily: popinsRegulr, color: Colors.black),
                          ),
                    TextButton.icon(
                      onPressed: _showImageSelectionDialog,
                      icon: Icon(Icons.photo, color: primaryColor),
                      label: const Text(
                        'Upload Profile Picture',
                        style: TextStyle(
                            fontFamily: popinsRegulr, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: popinsSemiBold, color: primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Start loading
                    });
                    await profileController.editFamilyMember(
                      auth: globals.accessToken.value,
                      id: member['id'].toString(),
                      roleId: member['role_id'].toString(),
                      profileImage: _profileImage,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      dob: dobController.text,
                      relationType: selectedRelation,
                    );

                    // Fetch updated list of family members
                    await profileController.fetchUserData2();

                    setState(() {
                      isLoading = false; // Stop loading
                    });

                    Navigator.of(context).pop();
                  },
                  child: isLoading
                      ? SpinKitFadingCircle(
                          color: primaryColor,
                          size: 50.0,
                        ) // Loading indicator// Show loading indicator
                      : Text(
                          'Save',
                          style: TextStyle(
                              fontFamily: popinsSemiBold, color: primaryColor),
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
