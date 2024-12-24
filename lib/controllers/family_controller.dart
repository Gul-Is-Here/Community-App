import 'dart:convert';
import 'package:community_islamic_app/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FamilyController extends GetxController {
  // Make classesList an observable list
  var classesList = <dynamic>[].obs;
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
      isLoading(true); // Start loading state
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
    isLoading(true); // Start loading
    const String url =
        'https://rosenbergcommunitycenter.org/api/RegisterClassApi';

    // Prepare the headers and body for the POST request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Assuming token is a Bearer token
    };

    Map<String, dynamic> body = {
      'class_id': classId, // Ensure classId is a String
      'id': id, // Ensure id is a String
      'relation_id': relationId, // Ensure relationId is a String
      'emergency_contact': emergencyContact,
      'emergencycontact_name': emergencyContactName,
      'allergies_detail': allergiesDetail,
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Request was successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled for the class.'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 423) {
        // Handle the error for already enrolled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already enrolled in this class.'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        // Handle other status codes
        print('Failed to register. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle network or other errors
      print('An error occurred: $e');
    } finally {
      isLoading(false); // Stop loading
    }
  }
}
