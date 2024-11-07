import 'package:flutter/material.dart';

import '../constants/color.dart';

Widget buildTimeCard({required String time, required String icon}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: 71,
            height: 34,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              margin: const EdgeInsets.all(0),
              elevation: 5,
              color: primaryColor,
              child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                    fontFamily: popinsSemiBold,
                    color: whiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 20,
          child: Container(
            width: 20.51,
            height: 20.51,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: primaryColor,
            ),
            child: Image.asset(
              icon,
              color: whiteColor,
            ),
          ),
        ),
      ],
    );
  }
