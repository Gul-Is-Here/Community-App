import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../constants/image_constants.dart';

class QiblahController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var locationCountry = "".obs;
  var locationCity = "".obs;
  late Animation<double> animation;
  late AnimationController animationController;
  double begin = 0.0;

  // Reactive variable to track the selected image
  Rx<String> selectedImage = (imageOptions[0]).obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Smooth 0.5 sec transition
    );
    animation = Tween(begin: 0.0, end: 0.0).animate(animationController);
    getLocation(); // Get location on init
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Show a message to the user if permission is denied
      Get.snackbar('Location Permission', 'Please grant location permission.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        locationCountry.value = placemarks[0].country ?? "";
        locationCity.value = placemarks[0].locality ?? "";
      }
    } catch (e) {
      Get.snackbar('Location Error', 'Failed to get location');
    }
  }

  // Call this function to update the Qiblah direction
  void updateQiblahDirection(double newQiblahDirection) {
    double newEnd = (newQiblahDirection * (3.141592653589793 / 180) * -1);

    animation = Tween(begin: begin, end: newEnd).animate(animationController);
    begin = newEnd;

    animationController.forward(from: 0);
  }
}
