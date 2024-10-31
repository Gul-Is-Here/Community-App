import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimationControllerController extends GetxController with SingleGetTickerProviderMixin {
  final isVisible = true.obs;
  late AnimationController _blinkController;

  @override
  void onInit() {
    super.onInit();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _blinkController.addListener(() {
      isVisible.value = !isVisible.value;
    });
  }

  // Remember to dispose the controller
  @override
  void onClose() {
    _blinkController.dispose();
    super.onClose();
  }
}
