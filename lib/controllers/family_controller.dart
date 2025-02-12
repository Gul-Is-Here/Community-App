import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/controllers/profileController.dart';

class FamilyController extends GetxController {
  var classesList = <dynamic>[].obs; // Reactive list for classes
  var isLoading = false.obs; // Reactive loading state
  var errorMessage = ''.obs; // Reactive error message

  @override
  void onInit() {
    super.onInit();
    fetchClasses(); // Fetch classes when initialized
  }

  /// Fetch Classes from API
  Future<void> fetchClasses() async {
    isLoading(true);
    const String url =
        'https://rosenbergcommunitycenter.org/api/ClassApi?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        classesList.value =
            data['data']['Classes'] ?? []; // Assign fetched classes
      } else {
        errorMessage.value =
            'Failed to load classes. Status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error occurred: $e';
    } finally {
      isLoading(false);
    }
  }

  /// Register User for Class
  Future<void> registerForClass({
    required BuildContext context,
    required String token,
    required int classId,
    required int userId,
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
      'id': userId.toString(),
      'relation_id': relationId,
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
        _updateEnrollmentStatus(classId); // Update local enrollment status
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled in the class!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        var responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['msg'] ?? 'Failed to enroll.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
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

  /// Update Enrollment Status Locally
  void _updateEnrollmentStatus(int classId) {
    var userData = ProfileController().userData;

    if (userData != null && userData['relations'] != null) {
      for (var relation in userData['relations']) {
        for (var enrollment in relation['hasenrollments'] ?? []) {
          if (enrollment['class_id'] == classId) {
            enrollment['_active'] = '1'; // Update status to Enrolled
            break;
          }
        }
      }
      ProfileController().userData.refresh(); // Trigger UI update
    }
  }
}
