import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommingSoonScreen extends StatelessWidget {
  const CommingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            )),
      ),
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset(
          icCommingSoon,
          height: 166,
          width: 166,
        ),
      ),
    );
  }
}
