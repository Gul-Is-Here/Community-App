import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';

class RegistrationController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var username = ''.obs;

  // Method to register user
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
      final response = await http.post(
        Uri.parse('https://rosenbergcommunitycenter.org/api/newregistration'),
        body: json.encode({
          'first_name': firstName.value,
          'last_name': lastName.value,
          'username': username.value,
          'email_address': email.value,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}"); // Debugging line
      print("Response Body: ${response.body}"); // Debugging line

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        print("JSON Response: ${jsonResponse}"); // Debugging line

        Get.snackbar("Success", "Registration successful.");
        Get.offAll(() => LoginScreen());
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
