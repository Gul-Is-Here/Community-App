import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomizedAsarWidget extends StatelessWidget {
  final String time;

  final String text;
  final Color color;
  final String IqamaTime;
  const CustomizedAsarWidget(
      {super.key,
      required this.IqamaTime,
      required this.text,
      required this.time,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: Color(0xFFC4F1DD),
                  borderRadius: BorderRadius.circular(20)),
            ),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: popinsSemiBold),
            ),
            5.heightBox,
            Text(
              time,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: popinsSemiBold),
            ),
            5.heightBox,
            Text(
              IqamaTime,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: popinsSemiBold),
            ),
            5.heightBox,
          ],
        ),
      ),
    );
  }
}
