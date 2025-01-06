import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/globals.dart';
import '../model/class_model.dart';
import 'login_controller.dart';

class ProfileController extends GetxController {
  var userData = <String, dynamic>{}.obs; // Observable map for userData
  var isLoading = true.obs; // Observable loading stat
  final _userDataController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get userDataStream => _userDataController.stream;

  final LoginController loginController = Get.put(LoginController());
  // var serData = {}.obs;

  // URL for profile update API
  final String profileUpdateApiUrl =
      "https://rosenbergcommunitycenter.org/api/ProfileUpdateApi?token=${globals.accessToken.value}&userid=${globals.userId.value}";

  @override
  void onInit() {
    super.onInit();
    globals.accessToken.value;
    fetchUserData2();

    fetchUserData(); // Fetch user data on initialization
  }

  /// Fetch user data from the API
  Future<void> fetchUserData() async {
    final url = Uri.parse('https://rosenbergcommunitycenter.org/api/user');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${globals.accessToken.value}',
        },
      );

      if (response.statusCode == 200) {
        print("Stream triggered, checking for data...");

        final jsonData = json.decode(response.body);
        globals.userId.value = jsonData['user']['id'].toString();
        print("User data fetched: $jsonData"); // Log the fetched data
        _userDataController.add(jsonData); // Emit the data
      } else {
        print("Failed to load user data. Status code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        _userDataController.addError('Failed to load user data');
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _userDataController.addError('Error fetching user data');
    }
  }

  @override
  void onClose() {
    _userDataController
        .close(); // Close the stream when the controller is disposed
    super.onClose();
  }

  Future<void> fetchUserData2() async {
    final url = Uri.parse('https://rosenbergcommunitycenter.org/api/user');
    isLoading.value = true;

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${globals.accessToken.value}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        userData.value = jsonData; // Store the entire response
        // print(userData);
      } else {
        print("Failed to load user data");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile data
  Future<void> postUserProfileData({
    required String firstName,
    required String lastName,
    required String gender,
    required String contactNumber,
    required String dob,
    required String emailAddress,
    required String profession,
    required String community,
    required String residentialAddress,
    required String state,
    required String city,
    required String zipCode,
  }) async {
    final headers = {
      "Authorization": "Bearer ${globals.accessToken.value}",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final body = {
      "userid": globals.userId.value,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "contact_number": contactNumber,
      "dob": dob,
      "email_address": emailAddress,
      "profession": profession,
      "community": community,
      "residential_address": residentialAddress,
      "state": state,
      "city": city,
      "zip_code": zipCode,
    };

    try {
      final response = await http.post(
        Uri.parse(profileUpdateApiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Profile updated successfully.");
      } else {
        print("Failed to update profile. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while updating profile: $e");
    }
  }

  Future<void> addFamilyMember({
    File? profileImage,
    required String firstName,
    required String lastName,
    required String relationType,
    required String dob,
    required String id,
    String? email,
  }) async {
    final url =
        Uri.parse('https://rosenbergcommunitycenter.org/api/AddRelationApi');

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Authorization": "Bearer ${globals.accessToken.value}",
    });

    // Add fields
    request.fields['token'] = globals.accessToken.value;
    request.fields['id'] = id;
    request.fields['relation_firstname'] = firstName;
    request.fields['relation_lastname'] = lastName;
    request.fields['email_address'] =
        email ?? ''; // Convert null to empty string
    request.fields['relation_dob'] = dob;
    request.fields['relation_type'] = relationType;

    // Add image if it's not null
    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'relation_image',
        profileImage.path,
      ));
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        fetchUserData2();
        print("Family member added successfully.");
      } else {
        print(
            "Failed to add family member. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while adding family member: $e");
    }
  }

  // Edit Profile Method
  // Method to edit family member
  Future<void> editFamilyMember({
    required String auth,
    required String id,
    required String roleId,
    required String firstName,
    required String lastName,
    required String dob,
    required String relationType,
    File? profileImage,
  }) async {
    try {
      isLoading(true);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://rosenbergcommunitycenter.org/api/EditRelationApi'),
      );
      request.fields['token'] = auth;
      request.fields['id'] = id;
      request.fields['role_id'] = roleId;
      request.fields['relation_firstname'] = firstName;
      request.fields['relation_lastname'] = lastName;
      request.fields['relation_dob'] = dob;
      request.fields['relation_type'] = relationType;

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'relation_image',
          profileImage.path,
        ));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        await fetchUserData2(); // Refresh user data after editing a family member
        print('Family member updated successfully');
      } else {
        print(
            'Failed to update family member. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
