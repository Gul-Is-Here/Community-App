import 'package:blinking_text/blinking_text.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/widgets/blinkContainer.dart';
import 'package:community_islamic_app/widgets/myText.dart';
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
  final String iqamatimes; // Iqama times

  @override
  Widget build(BuildContext context) {
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Default Iqama time
    // String iqamaTime = iqamatimes[namazName] ?? '02:00 PM';

    // // Check if the prayer is Maghrib and adjust the Iqama time accordingly
    // if (namazName == 'Maghrib') {
    //   iqamaTime = AppClass().calculateIqamaTime(timings); // Add and format
    // }

    // Set background color based on current prayer
    // Color backgroundColor = (currentPrayer == namazName)
    //         ? goldenColor
    //         : const Color(0xFFC4F1DD) // Highlight color for current prayer
    //     ; // Default color for other prayers

    return SizedBox(
      width: screenWidth * .15,
      height: screenHeight1 * .096,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 2,
          ),
          currentPrayer == namazName
              ? BlinkingContainer()
              : namazName == 'Jumuah'
                  ? BlinkingContainer()
                  : Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [lightColor, lightColor]),
                          borderRadius: BorderRadius.circular(20)),
                    ),
          const SizedBox(
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
                  child: MyText(
                    name,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: popinsBold,
                      color: whiteColor,
                    ),
                  ),
                )
              : MyText(
                  name,
                  style: TextStyle(
                    fontSize: 11,
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
                      child: MyText(
                        timings,
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: popinsRegulr,
                            // fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ))
                  : MyText(
                      timings,
                      style: TextStyle(
                          color: lightColor,
                          fontFamily: popinsRegulr,
                          // fontWeight: FontWeight.bold,
                          fontSize: 11),
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
                      child: MyText(
                        iqamatimes,
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: popinsRegulr,
                            // fontWeight: FontWeight,
                            fontSize: 11),
                      ))
                  : MyText(
                      iqamatimes, // Already formatted Iqama time
                      style: TextStyle(
                        fontSize: 11,
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
