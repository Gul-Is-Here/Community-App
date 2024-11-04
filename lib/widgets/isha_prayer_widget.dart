import 'package:blinking_text/blinking_text.dart';
import 'package:community_islamic_app/widgets/customized_mobile_layout.dart';
import 'package:flutter/material.dart';

import '../constants/color.dart';

class PrayerTimeWidget2 extends StatelessWidget {
  const PrayerTimeWidget2({
    super.key,
    required this.azanIcon,
    required this.iqamaIcon,
    required this.namazName,
    required this.name,
    required this.timings,
    required this.iqamatimes,
    required this.currentPrayer, // Current prayer passed from the controller
    required this.imageIcon,
  });

  final String imageIcon;
  final String azanIcon;
  final String iqamaIcon;
  final String currentPrayer; // Current prayer time passed to compare
  final String name; // Prayer name (e.g., Fajr, Dhuhr)
  final String namazName; // Specific namaz name for Iqama lookup
  final String timings; // Azan time (in "HH:mm" format)
  final Map<String, String> iqamatimes; // Iqama times

  @override
  Widget build(BuildContext context) {
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Default Iqama time
    String iqamaTime = iqamatimes[namazName] ?? 'Not available';

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

    return screenWidth < 450 || screenHeight1 < 900
        ? Stack(
            clipBehavior: Clip.none, // Allow the icon to overflow
            children: [
              SizedBox(
                width: screenWidth * .18,
                height: screenHeight1 * .1,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  color:
                      backgroundColor, // Background color changes dynamically
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: popinsMedium,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(height: 10), // Use SizedBox for spacing
                        Row(
                          children: [
                            Image.asset(
                              iqamaIcon,
                              width: 15,
                              height: 10,
                              // fit: BoxFit.contai,
                            ),
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
                                        timings), // Already formatted Iqama time
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: popinsMedium,
                                      color: whiteColor,
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Image.asset(
                              azanIcon,
                              width: 15,
                              height: 10,
                            ),
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
                                    iqamaTime, // Already formatted Iqama time
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: popinsMedium,
                                      color: whiteColor,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -17, // Adjust the vertical position of the icon
                left: 0, // Adjust horizontal position if needed
                right: 0, // Center the icon horizontally
                child: Image.asset(
                  imageIcon,
                  height: 24,
                  width: 24,
                  color: Colors.black45, // Icon color
                ),
              ),
            ],
          )
        : Stack(
            clipBehavior: Clip.none, // Allow the icon to overflow
            children: [
              SizedBox(
                width: 78,
                height: 85,
                child: Card(
                  color:
                      backgroundColor, // Background color changes dynamically
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: popinsMedium,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(height: 10), // Use SizedBox for spacing
                        Row(
                          children: [
                            Image.asset(
                              azanIcon,
                              width: 20,
                            ),
                            Text(
                              formatPrayerTimeToAmPm(
                                  timings), // Format Azan time
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: popinsMedium,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Image.asset(
                              iqamaIcon,
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              iqamaTime, // Already formatted Iqama time
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: popinsMedium,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: -16, // Adjust the vertical position of the icon
              //   left: 0, // Adjust horizontal position if needed
              //   right: 0, // Center the icon horizontally
              //   child: Image.asset(
              //     cardCircle,
              //     height: 24,
              //     width: 24,
              //     color: Colors.red, // Icon color
              //   ),
              // ),
              Positioned(
                top: -17, // Adjust the vertical position of the icon
                left: 0, // Adjust horizontal position if needed
                right: 0, // Center the icon horizontally
                child: Image.asset(
                  imageIcon,
                  height: 24,
                  width: 24,
                  color: Colors.black45, // Icon color
                ),
              ),
            ],
          );
  }
}
