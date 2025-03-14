import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';

class RegistrationController extends GetxController {
  var isLoading = false.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var username = ''.obs;

  // Check if email is unique
  Future<bool> isEmailUnique(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://rosenbergcommunitycenter.org/api/CheckUserEmail?email_address=$email"),
      );
      if (response.statusCode == 200) {
        return response.body == "1"; // 1 means email does not exist
      }
    } catch (e) {
      print("Email check error: $e");
    }
    return false; // Default to not unique to prevent registration with existing email
  }

  // Check if username is unique
  Future<bool> isUsernameUnique(String username) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://rosenbergcommunitycenter.org/api/CheckUser?username=$username"),
      );
      if (response.statusCode == 200) {
        return response.body == "1"; // 1 means username does not exist
      }
    } catch (e) {
      print("Username check error: $e");
    }
    return false;
  }

  // Register user
  Future<void> registerUser() async {
    if (firstName.value.isEmpty ||
        lastName.value.isEmpty ||
        email.value.isEmpty ||
        username.value.isEmpty) {
      Get.snackbar("Error", "All fields are required.");
      return;
    }

    isLoading.value = true;

    try {
      // Validate email and username before registering
      bool emailAvailable = await isEmailUnique(email.value);
      bool usernameAvailable = await isUsernameUnique(username.value);

      if (!emailAvailable) {
        Get.snackbar("Error", "Email is already in use.");
        isLoading.value = false;
        return;
      }

      if (!usernameAvailable) {
        Get.snackbar("Error", "Username is already taken.");
        isLoading.value = false;
        return;
      }

      final response = await http.post(
        Uri.parse('https://rosenbergcommunitycenter.org/api/newregistration'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'first_name': firstName.value,
          'last_name': lastName.value,
          'username': username.value,
          'email_address': email.value,
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == "success") {
          Get.snackbar("Success", "Registration successful!");
          Get.offAll(() => LoginScreen());
        } else {
          Get.snackbar(
              "Error", jsonResponse['message'] ?? "Registration successful.");
        }
      } else {
        Get.snackbar("Error",
            "Failed to register. Server responded with status code ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
