import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color.dart';
import '../controllers/profileController.dart';
import '../model/class_model.dart';

class FamilyMemberCard extends StatefulWidget {
  final String name;
  final String relationship;
  final String dob;
  final int age;
  final String heroTag;
  final String profileImage;
  final void Function() onTap;

  const FamilyMemberCard({
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
  final familyMemberController = Get.put(ProfileController());

  bool isExpanded = false;
  List<Class> availableClasses = [];
  Class? selectedAvailableClass;
  Class? selectedEnrolledClass;
  bool isLoading = true; // To track loading state
  String? errorMessage; // To store any error messages

  @override
  void initState() {
    super.initState();
    fetchClassesData(); // Fetch available classes when widget is initialized
  }

  // Fetch class data from the API
  void fetchClassesData() async {
    try {
      List<Class> classes = await familyMemberController.fetchClasses();
      setState(() {
        availableClasses = classes;
        selectedAvailableClass = classes.isNotEmpty ? classes[0] : null;
        isLoading = false; // Stop loading once data is fetched
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Stop loading on error
        errorMessage = 'Error fetching classes: $error'; // Set error message
      });
    }
  }

  // Enroll in a class and show confirmation
  void enrollInClass(Class selectedClass) {
    // Add your enrollment logic here
    // For example, you could call an API to enroll the family member
    // If successful:
    setState(() {
      selectedEnrolledClass =
          selectedClass; // Update the selected enrolled class
    });

    // Show confirmation message
    Get.snackbar(
      'Success',
      'Enrolled in ${selectedClass.className}!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  backgroundImage: NetworkImage(widget.profileImage),
                ),
                title: Text(
                  widget.name,
                  style: const TextStyle(fontFamily: popinsBold, fontSize: 13),
                ),
                subtitle: Text(
                  '${widget.relationship} - ${widget.dob} - ${widget.age} Years',
                  style: const TextStyle(fontFamily: popinsBold, fontSize: 10),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: whiteColor, width: 0),
                    borderRadius: BorderRadius.circular(30),
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
                    _buildGeneralInfo(),
                    const SizedBox(height: 20),
                    _buildAvailableClassesDropdown(),
                    const SizedBox(height: 20),
                    _buildEnrolledClassesDropdown(),
                  ],
                ),
              if (isLoading) // Show loading indicator
                const Center(child: CircularProgressIndicator()),
              if (errorMessage != null) // Show error message if exists
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
        _buildFloatingButtons(),
      ],
    );
  }

  Widget _buildGeneralInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('GENERAL INFORMATION'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildInfoRow('Name', widget.name),
            _buildInfoRow('Relation', widget.relationship),
            _buildInfoRow('DOB', widget.dob),
            _buildInfoRow('Age', widget.age.toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailableClassesDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('AVAILABLE CLASSES'),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 30,
            child: Card(
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: DropdownButton<Class>(
                  dropdownColor: Colors.white,
                  underline: Container(), // Remove default underline
                  items: availableClasses.map((Class value) {
                    return DropdownMenuItem<Class>(
                      value: value,
                      child: Text(
                        value.className,
                        style: const TextStyle(
                            fontFamily: popinsRegulr, fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (Class? newClass) {
                    setState(() {
                      selectedAvailableClass = newClass;
                    });
                  },
                  hint: selectedAvailableClass == null
                      ? const Text(
                          'Select Class',
                          style:
                              TextStyle(fontFamily: popinsBold, fontSize: 13),
                        )
                      : Text(
                          selectedAvailableClass!.className,
                          style: const TextStyle(
                              fontFamily: popinsBold, fontSize: 13),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnrolledClassesDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('CLASSES ENROLLED'),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 40,
            child: Card(
              color: const Color(0xFF1EC7CD),
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: DropdownButton<Class>(
                  dropdownColor: Colors.white,
                  underline: Container(), // Remove default underline
                  items: availableClasses.map((Class value) {
                    return DropdownMenuItem<Class>(
                      value: value,
                      child: Text(
                        value.className,
                        style: const TextStyle(
                            fontFamily: popinsRegulr, fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (Class? newClass) {
                    setState(() {
                      selectedEnrolledClass = newClass;
                    });
                  },
                  hint: selectedEnrolledClass == null
                      ? const Text(
                          'Enroll in Class',
                          style:
                              TextStyle(fontFamily: popinsBold, fontSize: 13),
                        )
                      : Text(
                          selectedEnrolledClass!.className,
                          style: const TextStyle(
                              fontFamily: popinsBold, fontSize: 13),
                        ),
                  // Add enroll action here
                  onTap: () {
                    if (selectedAvailableClass != null) {
                      enrollInClass(selectedAvailableClass!);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 28,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: popinsSemiBold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: popinsRegulr, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(fontFamily: popinsRegulr, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
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
    );
  }
}
