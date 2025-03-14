import 'dart:convert';
import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteAccountController extends GetxController {
  Future<void> deleteMyAccount(String token) async {
    final String url =
        "https://rosenbergcommunitycenter.org/api/DeleteMyAccountAPI";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Success response
        final Map<String, dynamic> responseBody = json.decode(response.body);
        Get.snackbar('Account Deleted', "Account deleted Successfully",
            colorText: whiteColor, 
            backgroundColor: primaryColor,
            snackStyle: SnackStyle.FLOATING);
      } else {
        // Handle failure
        print("❌ Failed to delete account. Status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }
}
