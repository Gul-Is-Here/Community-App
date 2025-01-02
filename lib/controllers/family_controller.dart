import 'dart:convert';
import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/controllers/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FamilyController extends GetxController {
  // Make classesList an observable list
  var classesList = <dynamic>[].obs;
  // var inrolments = <dynamic>[].obs; // Make it reactive

  var isLoading = false.obs; // Observable loading state
  var errorMessage = ''.obs; // Observable for error messages

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }

  // Method to get data from API and save to a dynamic variable
  Future<void> fetchData() async {
    try {
      // isLoading(true); // Start loading state
      // Replace with your API call logic
      final response = await http.get(Uri.parse(
          'https://rosenbergcommunitycenter.org/api/ClassApi?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'));

      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = json.decode(response.body);

        // Store the classes data in a reactive list
        classesList.value = data['data']['Classes'];

        // Debug print to check the response data
        for (var singleClass in classesList) {
          print(singleClass[
              'class_name']); // Accessing class_name field for each class
        }
      } else {
        errorMessage.value =
            'Failed to load data. Status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error occurred: $e';
    } finally {
      isLoading(false); // Stop loading
    }
  }

  Future<void> registerForClass({
    required BuildContext context,
    required String token,
    required int classId,
    required int id,
    required String relationId,
    required String emergencyContact,
    required String emergencyContactName,
    required String allergiesDetail,
  }) async {
    isLoading(true);

    const String url =
        'https://rosenbergcommunitycenter.org/api/RegisterClassApi';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      'class_id': classId.toString(),
      'id': id.toString(),
      'relation_id': relationId.toString(),
      'emergency_contact': emergencyContact,
      'emergencycontact_name': emergencyContactName,
      'allergies_detail': allergiesDetail,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ProfileController().userDataStream;
        // inrolments.refresh();
        print(ProfileController().userData); // Fetch updated user data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled for the class.'),
            backgroundColor: Colors.green,
          ),
        );
      } else
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already enrolled in this class.'),
            backgroundColor: Colors.orange,
          ),
        );

      print('Error: ${response.body}');
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading(false);
    }
  }

// Method to update the enrollment status in the observable list after a successful enrollment
  void _updateEnrollmentStatus(int classId) {
    for (var enrollment in ProfileController().userData['relations']
        ['hasenrollments']) {
      if (enrollment['class_id'] == classId) {
        enrollment['_active'] = '1'; // Mark the class as 'Enrolled'
        break;
      }
    }
    ProfileController()
        .userData
        .refresh(); // Trigger GetX to refresh the userData observable
  }
}
