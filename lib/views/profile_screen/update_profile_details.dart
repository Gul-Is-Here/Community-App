import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import '../../constants/color.dart';
import '../../controllers/profileController.dart';
import '../../widgets/profile_dropdown_widget.dart';
import '../../widgets/profile_text_widget.dart';

class UpdateProfileDetails extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UpdateProfileDetails({Key? key, required this.userData})
      : super(key: key);

  @override
  _UpdateProfileDetailsState createState() => _UpdateProfileDetailsState();
}

class _UpdateProfileDetailsState extends State<UpdateProfileDetails> {
  final ProfileController profileController = Get.put(ProfileController());

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController dobController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController zipCodeController;
  late TextEditingController professionController;

  String? _selectedCommunity;
  String? _selectedGender;
  String? _selectedState;

  final List<String> communities = [
    "Walnut Creek",
    "Sunset Crossing",
    "Summer Lakes",
    "Bonbrook Plantation",
    "Stone Creek",
    "Oaks of Rosenberg",
    "Rose Ranch",
    "Lakes of William Ranch",
    "Bryan Crossing",
    "River Mists",
    "Other"
  ];

  final List<String> genders = ["Male", "Female"];
  final List<String> states = ["Texas"];

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController(text: widget.userData['first_name']);
    lastNameController =
        TextEditingController(text: widget.userData['last_name']);
    emailController = TextEditingController(text: widget.userData['email']);
    phoneNumberController =
        TextEditingController(text: widget.userData['number']);
    dobController = TextEditingController(text: widget.userData['dob']);
    addressController =
        TextEditingController(text: widget.userData['residential_address']);
    cityController = TextEditingController(text: widget.userData['city']);
    zipCodeController =
        TextEditingController(text: widget.userData['zip_code']);
    professionController =
        TextEditingController(text: widget.userData['profession']);

    _selectedCommunity = widget.userData['community'];
    _selectedGender = widget.userData['gender'] ?? 'Male';
    _selectedState = widget.userData['state'] ?? 'Texas';
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    dobController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    professionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      overlayBackgroundColor: Colors.black,
      appIcon: SpinKitFadingCircle(
        color: primaryColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Edit Profile Info',
            style: TextStyle(
                fontFamily: popinsMedium, color: whiteColor, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                buildTextField(
                    label: "First Name", controller: firstNameController),
                buildTextField(
                    label: "Last Name", controller: lastNameController),
                buildTextField(
                    label: "Email Address", controller: emailController),
                buildTextField(
                    label: "Phone No", controller: phoneNumberController),
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
                buildTextField(
                   label: "Residential Address",
                    controller: addressController),
                buildTextField(label: "City", controller: cityController),
                buildDropdownField(
                    label: "Community",
                    value: _selectedCommunity,
                    items: communities,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCommunity = newValue;
                      });
                    }),
                buildDropdownField(
                    label: "Gender",
                    value: _selectedGender,
                    items: genders,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    }),
                buildDropdownField(
                    label: "State",
                    value: _selectedState,
                    items: states,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    }),
                buildTextField(
                    label: "Zip Code", controller: zipCodeController),
                buildTextField(
                    label: "Profession", controller: professionController),
                const SizedBox(height: 24),
                _buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
 
  Widget _buildUpdateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });

            await profileController.postUserProfileData(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              gender: _selectedGender ?? 'Male',
              contactNumber: phoneNumberController.text,
              dob: dobController.text,
              emailAddress: emailController.text,
              profession: professionController.text,
              community: _selectedCommunity ?? '',
              residentialAddress: addressController.text,
              state: _selectedState ?? 'Texas',
              city: cityController.text,
              zipCode: zipCodeController.text,
            );

            setState(() {
              _isLoading = false;
            });

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Profile updated successfully!",
                  style: TextStyle(fontFamily: popinsSemiBold),
                ),
                backgroundColor: primaryColor,
              ),
            );

            // Navigate back after a delay to allow the user to see the message
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(30, 30),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.elliptical(30, 30),
              topRight: Radius.circular(5),
            ),
          ),
          shadowColor: const Color.fromARGB(255, 252, 254, 255),
          elevation: 8,
        ),
        child: Text(
          'UPDATE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
