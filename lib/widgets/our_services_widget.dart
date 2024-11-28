import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';

class OurServicesWidget extends StatelessWidget {
  final String title;
  final String image;
  void Function() onTap;
  OurServicesWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.topLeft,
        height: 113,
        width: 113,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9.33,
            horizontal: 6.5,
          ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 11, fontFamily: popinsSemiBold, color: whiteColor),
          ),
        ),
      ),
    );
  }
}

// Function to format prayer time


