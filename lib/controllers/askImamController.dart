import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AskImamController extends GetxController {
  final isLoading = false.obs;
  // final isSuccess = false.obs;
  final errorMessage = ''.obs;
  RxInt selectedOption = (-1).obs; // -1 means no option selected

  Future<void> submitForm({
    required String name,
    required String emailPhone,
    required String message,
    required String number,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final Map<String, String> body = {
        'name': name,
        'number': number,
        'email': emailPhone,
        'message': message,
      };

      const String baseUrl =
          'https://rosenbergcommunitycenter.org/api/AskImamAPI';
      const String accessToken = '7b150e45-e0c1-43bc-9290-3c0bf6473a51332';
      final Uri uri = Uri.parse('$baseUrl?access=$accessToken');

      final response = await http.post(
        uri,
        body: body,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Your question has been submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit question. Status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value =
          'An error occurred. Please check your internet connection.';
      print("Error: ${e.toString()}");
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
