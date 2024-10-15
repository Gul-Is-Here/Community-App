import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Projectbackground extends StatelessWidget {
  final String title;
  const Projectbackground({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            height: screenHeight * .25,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage(qiblaTopBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontFamily: popinsMedium,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ),
          10.heightBox,
        ],
      ),
    );
  }
}
