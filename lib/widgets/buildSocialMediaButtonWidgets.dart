import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';

Widget buildSocialMediaButton({
    required BuildContext context,
    required String image,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: lightColor,
            child: Image.asset(
              image,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: popinsRegulr,
              fontSize: 12,
              color: whiteColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }