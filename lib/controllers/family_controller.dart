import 'dart:convert';

import 'package:community_islamic_app/constants/globals.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FamilyController extends GetxController {
  List<dynamic> classesList = [];
  var isLoading = false.obs; // Observable loading state

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Method to get data from API and save to a dynamic variable
  Future<void> fetchData() async {
    // Replace with your API call logic
    final response = await http.get(Uri.parse(
        'https://rosenbergcommunitycenter.org/api/ClassApi?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'));

    if (response.statusCode == 200) {
      // Decode the JSON response
      var data = json.decode(response.body);

      // Store the classes data in a list
      classesList = data['data']['Classes'];

      // You can now use the `classesList` to access each class
      for (var singleClass in classesList) {
        print(singleClass[
            'class_name']); // Accessing class_name field for each class
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> registerForClass({
    required String token,
    required String classId,
    required String id,
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
        print('Successfully registered for class: ${response.body}');
      } else {
        // Handle the error
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
