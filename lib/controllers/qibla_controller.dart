import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class QiblahController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var locationCountry = "".obs;
  var locationCity = "".obs;

  late Animation<double> animation;
  late AnimationController animationController;

  double begin = 0.0; // Initial rotation value in radians

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500), // Smooth 0.5-second animation
    );
    animation = Tween(begin: 0.0, end: 0.0).animate(animationController);
    getLocation(); // Fetch location data on initialization
  }

  /// Fetches the user's location and updates the city and country names.
  Future<void> getLocation() async {
    print('==========>>>>');
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Inform the user about missing permissions
        Get.snackbar(
          'Location Permission',
          'Please grant location permissions to determine Qiblah direction.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        locationCountry.value = placemarks[0].country ?? "Unknown Country";
        locationCity.value = placemarks[0].locality ?? "Unknown City";
      }
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Unable to determine location. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Updates the Qiblah direction and smoothly animates the compass rotation.
  void updateQiblahDirection(double newQiblahDirection) {
    // Convert the new Qiblah direction to radians
    double newEnd = newQiblahDirection * (-3.141592653589793 / 180);

    // Update animation only if the direction changes
    if (newEnd != begin) {
      animation = Tween(begin: begin, end: newEnd).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut, // Smoother transition
        ),
      );
      begin = newEnd; // Update the start position for the next change
      animationController.forward(from: 0); // Start the animation
    }
  }

  // @override
  // void onClose() {
  //   animationController.dispose();
  //   super.onClose();
  // }
}
