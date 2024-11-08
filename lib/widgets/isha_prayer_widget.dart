import 'package:blinking_text/blinking_text.dart';
import 'package:community_islamic_app/widgets/customized_mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/color.dart';

class PrayerTimeWidget2 extends StatelessWidget {
  const PrayerTimeWidget2({
    super.key,
    // required this.azanIcon,
    // required this.iqamaIcon,
    required this.namazName,
    required this.name,
    required this.timings,
    required this.iqamatimes,
    required this.currentPrayer, // Current prayer passed from the controller
    required this.imageIcon,
  });

  final String imageIcon;
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
    String iqamaTime = iqamatimes ?? 'Not available';

    // Check if the prayer is Maghrib and adjust the Iqama time accordingly
    if (namazName == 'Maghrib') {
      iqamaTime = formatPrayerTimeToAmPm(
        addMinutesToPrayerTime(timings, 5), // Add and format
      );
    }

    // Set background color based on current prayer
    Color backgroundColor = (currentPrayer == namazName)
            ? const Color(0xFF5B7B79)
            : const Color(0xFF042838) // Highlight color for current prayer
        ; // Default color for other prayers

    return Stack(
      clipBehavior: Clip.none, // Allow the icon to overflow
      children: [
        SizedBox(
          width: screenWidth * .31,
          height: screenHeight1 * .07,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    colors: [Color(0xFF5B7B79), Color(0xFF5B7B79)])),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        imageIcon,
                        fit: BoxFit.cover,
                        height: 20,
                        width: 19,
                        color: whiteColor,
                      ),
                      2.widthBox,
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsMedium,
                          color: whiteColor,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          currentPrayer == namazName
                              ? Center(
                                  child: BlinkText(
                                    formatPrayerTimeToAmPm(timings),
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: popinsMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    endColor: primaryColor,
                                    duration: const Duration(seconds: 4),
                                  ),
                                )
                              : Text(
                                  formatPrayerTimeToAmPm(
                                      timings), // Format Azan time
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: popinsMedium,
                                    color: whiteColor,
                                  ),
                                ),
                          5.heightBox,
                          currentPrayer == namazName
                              ? Center(
                                  child: BlinkText(
                                    iqamaTime,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: popinsMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    endColor: primaryColor,
                                    duration: const Duration(seconds: 4),
                                  ),
                                )
                              : Text(
                                  formatPrayerTimeToAmPm(
                                      iqamaTime), // Already formatted Iqama time
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: popinsMedium,
                                    color: whiteColor,
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                  // const SizedBox(height: 10), // Use SizedBox for spacing

                  // const SizedBox(height: 2),
                  // Row(
                  //   children: [
                  //     // Image.asset(
                  //     //   azanIcon,
                  //     //   width: 15,
                  //     //   height: 10,
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: -19, // Adjust the vertical position of the icon
        //   left: 0, // Adjust horizontal position if needed
        //   right: 0, // Center the icon horizontally
        //   child: Image.asset(
        //     imageIcon,
        //     height: 24,
        //     width: 24,
        //     color: Colors.black45, // Icon color
        //   ),
        // ),
      ],
    );
  }
}
