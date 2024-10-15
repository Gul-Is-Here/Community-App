import 'package:community_islamic_app/views/about_us/about_us.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/color.dart';
import '../../widgets/project_background.dart';

class GalleryVideosScreen extends StatelessWidget {
  final String catHash;
  final String categoryName;

  const GalleryVideosScreen(
      {required this.catHash, required this.categoryName, super.key});

  @override
  Widget build(BuildContext context) {
    // You can use catHash to fetch or display specific videos
    return Scaffold(
      body: Column(
        children: [
          const Projectbackground(title: 'GALLERY'),
          Container(
            alignment: Alignment.centerLeft,
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(color: primaryColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                textAlign: TextAlign.left,
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: popinsRegulr,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          150.heightBox,
          const Center(
            child: Text(
              'COOMING SOON',
              style: TextStyle(fontFamily: popinsRegulr),
            ),
          )
        ],
      ),
    );
  }
}
