import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_classes/rate_our_app_services.dart';

class RateAppController extends GetxController {
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();

  Future<void> sendRating({
    required int rating,
    String? email,
    String? review,
    String? attachmentPath,
  }) async {
    try {
      isLoading.value = true;
      bool success = await _apiService.rateApp(
        rating: rating,
        email: email,
        review: review,
        attachmentPath: attachmentPath,
      );

      if (success) {
        Get.snackbar("Success", "Rating Submitted Successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: secondaryColor,
            colorText: Get.theme.cardColor);
      } else {
        Get.snackbar("Error", "Failed to submit rating",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Get.theme.cardColor);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
