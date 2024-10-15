import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';

class CusTomizedCardWidget extends StatelessWidget {
  final String title;
  final String imageIcon;
  final void Function() onTap;

  const CusTomizedCardWidget({
    super.key,
    required this.title,
    required this.imageIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Define fixed dimensions for the card
    const double cardWidth = 100; // Width of the card
    const double cardHeight = 100; // Height of the card
    const double imageHeight = 50; // Height of the image

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 0.0), // Adjust vertical padding if needed
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Card(
            color: Colors.white,
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10, // Space between top of the card and image
                ),
                Image.asset(
                  imageIcon,
                  width: cardWidth *
                      0.6, // Width of the image relative to card width
                  height: imageHeight, // Fixed height for the image
                ),
                const SizedBox(height: 8), // Space between image and title
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: popinsMedium,
                    fontSize: 11, // Fixed font size
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
