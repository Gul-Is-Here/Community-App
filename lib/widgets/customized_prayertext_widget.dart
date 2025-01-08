import 'package:blinking_text/blinking_text.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/widgets/blinkContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_classes/app_class.dart';
import '../constants/color.dart';

class PrayerTimeWidget extends StatelessWidget {
  const PrayerTimeWidget({
    super.key,
    // required this.azanIcon,
    // required this.iqamaIcon,
    required this.namazName,
    required this.name,
    required this.timings,
    required this.iqamatimes,
    required this.currentPrayer, // Current prayer passed from the controller
  });

  // final String azanIcon;
  // final String iqamaIcon;
  final String currentPrayer; // Current prayer time passed to compare
  final String name; // Prayer name (e.g., Fajr, Dhuhr)
  final String namazName; // Specific namaz name for Iqama lookup
  final String timings; // Azan time (in "HH:mm" format)
  final Map<String, String> iqamatimes; // Iqama times

  @override
  Widget build(BuildContext context) {
    final appClass = AppClass();
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Default Iqama time
    String iqamaTime = iqamatimes[namazName] ?? 'Not available';

    // Check if the prayer is Maghrib and adjust the Iqama time accordingly
    if (namazName == 'Maghrib') {
      iqamaTime = appClass.formatPrayerTimeToAmPm(
        appClass.addMinutesToPrayerTime(timings, 5), // Add and format
      );
    }

    // Set background color based on current prayer
    Color backgroundColor = (currentPrayer == namazName)
            ? goldenColor
            : const Color(0xFFC4F1DD) // Highlight color for current prayer
        ; // Default color for other prayers

    return SizedBox(
      width: screenWidth * .15,
      height: screenHeight1 * .082,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 2,
          ),
          currentPrayer == namazName
              ? BlinkingContainer()
              : Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [lightColor, lightColor]),
                      borderRadius: BorderRadius.circular(20)),
                ),
          SizedBox(
            height: 5,
          ),
          currentPrayer == namazName
              ? ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                          colors: [
                        goldenColor,
                        goldenColor2
                      ], // Define your gradient colors
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)
                      .createShader(bounds),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: popinsBold,
                      color: whiteColor,
                    ),
                  ),
                )
              : Text(
                  name,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: popinsBold,
                    color: lightColor,
                  ),
                ),
          // const Spacer(),
          SizedBox(
            height: 2,
          ),
          Column(
            children: [
              currentPrayer == namazName
                  ? ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                goldenColor,
                                goldenColor
                              ], // Define your gradient colors
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)
                              .createShader(bounds),
                      child: Text(
                        appClass.formatPrayerTimeToAmPm(timings),
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: popinsRegulr,
                            // fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ))
                  : Text(
                      appClass.formatPrayerTimeToAmPm(timings),
                      style: TextStyle(
                          color: lightColor,
                          fontFamily: popinsRegulr,
                          // fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
              currentPrayer == namazName
                  ? ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              goldenColor,
                              goldenColor
                            ], // Define your gradient colors
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                      child: Text(
                        iqamaTime,
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: popinsRegulr,
                            // fontWeight: FontWeight,
                            fontSize: 10),
                      ))
                  : Text(
                      iqamaTime, // Already formatted Iqama time
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: popinsRegulr,
                        color: lightColor,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
