import 'dart:io';

import 'package:community_islamic_app/constants/globals.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../views/auth_screens/login_screen.dart';
import '../views/home_screens/home.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  // var isLoggedIn = ''.obs; // Observable login state
  final RxBool sendUsername = false.obs;
  final RxBool sendPassword = false.obs;
  final RxString message = ''.obs; // For success/error messages
  var profileImage = Rx<File?>(null);
  var relationAvatar = 'male.png'.obs;
  @override
  void onInit() {
    super.onInit();
    // Check login status when controller initializes
    // isLoggedInd();
    isLoggedIn();
    loadAuthToken();
    _loadaId();
  }

  void toggleSendUsername(bool value) {
    sendUsername.value = value;
  }

  void toggleSendPassword(bool value) {
    sendPassword.value = value;
  }

  Future<void> loginUser() async {
    // Validate email and password
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Please enter both email and password.");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://rosenbergcommunitycenter.org/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': email.value,
          'password': password.value,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final userDetails = jsonResponse["user_details"];
        if (userDetails != null) {
          globals.userId.value = userDetails["id"]?.toString() ?? '';
          globals.accessToken.value = jsonResponse["access_token"] ?? '';
          print(globals.accessToken.value);

          // Store login status and access token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('accessToken', globals.accessToken.value);
          print(globals.accessToken.value);
          await prefs.setString('userid', globals.userId.value);

          Get.snackbar("Success", "Login successful.");
          Get.off(() => const Home()); // Navigate to Home screen
        } else {
          Get.snackbar("Error", "Invalid login credentials.");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to login. Please check your email and password.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    // Clear login status and access token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('accessToken');
    await prefs.remove('userid');
    globals.userId.value = '';
    globals.accessToken.value = '';
    await prefs.setBool('isLoggedIn', false);

    Get.snackbar("Success", "Logged out successfully.");
    Get.offAll(() => LoginScreen()); // Navigate back to login screen
  }

  Future<bool> isLoggedIn() async {
    // Check login status from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> loadAuthToken() async {
    // Retrieve the access token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('accessToken');
    print(prefs.getString('accessToken'));
    print('Token : $storedToken');

    if (storedToken != null) {
      globals.accessToken.value = storedToken;
    }
  }

  Future<void> _loadaId() async {
    // Retrieve the access token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('userid');

    if (storedId != null) {
      globals.userId.value = storedId;
    }
  }

  // Upload image
  Future<void> uploadImage(File imageFile, String relationAvatar) async {
    if (globals.userId.value.isEmpty || globals.accessToken.value.isEmpty) {
      Get.snackbar("Error", "User not logged in.");
      return;
    }

    final uri =
        Uri.parse('https://rosenbergcommunitycenter.org/api/ImageUploadApi');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${globals.accessToken.value}';

    // Add form data
    request.fields['id'] = globals.userId.value;
    request.fields['relation_avatar'] = relationAvatar;

    // Add image file
    final image = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(image);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Image uploaded successfully.");
      } else {
        Get.snackbar("Error",
            "Failed to upload image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
// Reset Password APi Method

  Future<void> resetPassword({
    required String email,
    required bool sendUsername,
    required bool sendPassword,
  }) async {
    isLoading.value = true; // Show loading indicator
    message.value = ''; // Clear previous messages
    // API endpoint
    final url = Uri.parse(
      'https://rosenbergcommunitycenter.org/api/ResetUserPassAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332',
    );

    // Prepare form data
    final request = http.MultipartRequest('POST', url)
      ..fields['email'] = email
      ..fields['username'] = sendUsername ? 'yes' : 'no'
      ..fields['password'] = sendPassword ? 'yes' : 'no';

    // Send the request
    final response = await request.send();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    // Handle the response
    if (response.statusCode == 200) {
      message.value = 'Password reset email sent successfully!';
    } else if (response.statusCode == 403) {
      message.value = 'Error: Access Denied.';
    } else if (response.statusCode == 404) {
      message.value = 'Error: Please enter a valid email address.';
    } else {
      print('Failed with status code: ${response.statusCode}');
    }
    isLoading.value = false; // Hide loading indicator
  }
}
