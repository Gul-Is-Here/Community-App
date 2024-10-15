import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomizedPrayerTimeWidget extends StatelessWidget {
  final String time;
  final String image;
  final String text;
  final String azazName;
  final Color color;
  const CustomizedPrayerTimeWidget(
      {super.key,
      required this.text,
      required this.time,
      required this.azazName,
      required this.image,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                  color: Colors.white, fontSize: 11, fontFamily: popinsRegulr),
            ),
            5.heightBox,
            Image.asset(
              image,
              height: 25,
              width: 25,
            ),
            5.heightBox,
            Text(
              azazName,
              style: TextStyle(
                  color: Colors.white, fontSize: 11, fontFamily: popinsRegulr),
            ),
            5.heightBox,
            Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 11, fontFamily: popinsRegulr),
            )
          ],
        ),
      ),
    );
  }
}
