import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CusTomizedCardWidget2 extends StatelessWidget {
  final String title;
  final String imageIcon;
  final void Function() onTap;

  const CusTomizedCardWidget2({
    super.key,
    required this.title,
    required this.imageIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = screenWidth * 0.33; // Standardized card size

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: cardSize, // Fixed card width
          height: cardSize + 20, // Fixed card height
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(width: 5, color: primaryColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16), // Consistent padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    imageIcon,
                    fit: BoxFit.cover,
                    width: 60, // Fixed image width
                    height: 60, // Fixed image height
                  ),
                  10.heightBox, // Consistent spacing
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: popinsRegulr,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 10, // Fixed font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
