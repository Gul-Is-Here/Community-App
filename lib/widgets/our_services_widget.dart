import 'package:community_islamic_app/widgets/myText.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          alignment: Alignment.topLeft,
          height: screenHeight * .15,
          width: screenwidth * .288,
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
            child: MyText(
              title,
              style: TextStyle(
                  fontSize: 11, fontFamily: popinsSemiBold, color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}

// Function to format prayer time
