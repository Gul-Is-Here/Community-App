import 'package:community_islamic_app/views/about_us/about_us.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/color.dart';
import '../../widgets/project_background.dart';

class AskImamScreen extends StatelessWidget {
  const AskImamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // You can use catHash to fetch or display specific videos
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // ignore: prefer_const_constructors
          Projectbackground(
            title: 'ASK IMAM',
          ),
          Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(color: primaryColor),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  'COMMING SOON',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: popinsBold),
                ),
              ),
            ),
          ),
          150.heightBox,
          const Center(
            child: Text(
              'COMMING SOON',
              style: TextStyle(fontFamily: popinsRegulr),
            ),
          )
        ],
      ),
    );
  }
}
