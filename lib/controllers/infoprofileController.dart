import 'dart:io';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../constants/globals.dart';

class Infoprofilecontroller extends GetxController {
  Rx<File?> profileImage = Rx<File?>(null);
  Rx<String?> selectedAvatar = Rx<String?>(null);
  Rx<String?> dummyAvatar = Rx<String?>(null);
  var isLoading = false.obs;

  // Avatar list
  List<String> avatar = [
    'assets/images/male.png',
    'assets/images/female.png',
    'assets/images/boy.png',
    'assets/images/girl.png'
  ];

  Future<void> pickImage(String userId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
      selectedAvatar.value = null; // Clear avatar when image is selected

      // Show confirmation dialog
      bool? confirmUpload = await Get.dialog<bool>(
        AlertDialog(
          title: Text(
            'Confirm Upload',
            style: TextStyle(fontFamily: popinsBold, color: primaryColor),
          ),
          content: const Text(
            'Are you sure you want to upload this picture?',
            style: TextStyle(fontFamily: popinsMedium),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false), // User pressed No
              child: const Text(
                'No',
                style: TextStyle(fontFamily: popinsMedium, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(result: true), // User pressed Yes
              child: Text(
                'Yes',
                style: TextStyle(fontFamily: popinsMedium, color: primaryColor),
              ),
            ),
          ],
        ),
      );

      // If the user confirmed the upload, proceed to upload the image
      if (confirmUpload == true) {
        await uploadProfileImage(userId);
      } else {
        // If the user did not confirm, clear the selected image
        profileImage.value = null;
      }
    }
  }

  void selectAvatar(String avatarPath, String userId) {
    selectedAvatar.value =
        avatarPath.split('/').last; // Set selected avatar name
    dummyAvatar.value = avatarPath; // Set dummy avatar path
    profileImage.value = null; // Clear image when avatar is selected
    uploadProfileImage(userId); // Automatically upload after selecting avatar
  }

  Future<void> uploadProfileImage(String userId) async {
    isLoading.value = true; // Show loading indicator
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://rosenbergcommunitycenter.org/api/ImageUploadApi'),
    );
    request.headers['Authorization'] = 'Bearer ${globals.accessToken.value}';
    request.fields['id'] = globals.userId.value;

    if (profileImage.value != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', profileImage.value!.path));
    }

    if (selectedAvatar.value != null) {
      request.fields['relation_avatar'] = selectedAvatar.value!;
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image/Avatar uploaded successfully!');
        // Fetch updated user data using the existing instance
        Get.find<ProfileController>().fetchUserData();
        profileImage.value = null; // Clear profile image after upload
        selectedAvatar.value = null; // Clear selected avatar
      } else {
        print('Failed to upload image/avatar: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image/avatar: $e');
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }
}
